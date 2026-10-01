-- Run once in the Supabase SQL editor. All access is server-side.
create table public.products(id text primary key,name text not null,category text not null,price integer not null check(price>0),old_price integer not null default 0,tag text not null default '',description text not null,specs jsonb not null,image text not null,stock integer not null check(stock>=0));
create table public.profiles(id uuid primary key default gen_random_uuid(),google_id text unique not null,email text not null,name text not null);
create table public.shop_sessions(id uuid primary key default gen_random_uuid(),token_hash text unique not null,profile_id uuid references public.profiles(id),expires_at timestamptz not null);
create table public.cart_items(session_id uuid references public.shop_sessions(id) on delete cascade,product_id text references public.products(id),quantity integer not null check(quantity between 1 and 10),primary key(session_id,product_id));
create table public.orders(id uuid primary key default gen_random_uuid(),reference text unique not null,profile_id uuid references public.profiles(id) not null,checkout_key uuid not null,shipping jsonb not null,email text not null,items jsonb not null,subtotal integer not null,delivery integer not null,total integer not null,status text not null default 'received',email_status text not null default 'pending',created_at timestamptz not null default now(),unique(profile_id,checkout_key));
alter table public.products enable row level security;
alter table public.profiles enable row level security;
alter table public.shop_sessions enable row level security;
alter table public.cart_items enable row level security;
alter table public.orders enable row level security;
revoke all on public.products,public.profiles,public.shop_sessions,public.cart_items,public.orders from anon,authenticated;
grant all on public.products,public.profiles,public.shop_sessions,public.cart_items,public.orders to service_role;
create or replace function public.place_order(p_session uuid,p_key uuid,p_shipping jsonb) returns jsonb language plpgsql security definer set search_path=public as $$
declare s shop_sessions%rowtype; o orders%rowtype; line record; rows_json jsonb='[]'; subtotal_value integer=0; delivery_value integer; customer_email text;
begin
 select * into s from shop_sessions where id=p_session and expires_at>now() for update;
 if s.profile_id is null then raise exception 'Sign in required'; end if;
 select * into o from orders where profile_id=s.profile_id and checkout_key=p_key;
 if found then return to_jsonb(o); end if;
 for line in select p.*,c.quantity from cart_items c join products p on p.id=c.product_id where c.session_id=p_session order by p.id for update of p,c loop
  if line.stock<line.quantity then raise exception 'Product no longer available'; end if;
  subtotal_value=subtotal_value+line.price*line.quantity;
  rows_json=rows_json||jsonb_build_array(jsonb_build_object('id',line.id,'name',line.name,'price',line.price,'quantity',line.quantity,'image',line.image));
  update products set stock=stock-line.quantity where id=line.id;
 end loop;
 if subtotal_value=0 then raise exception 'Cart is empty'; end if;
 delivery_value=case when subtotal_value>=100000 then 0 else 3500 end;
 select email into customer_email from profiles where id=s.profile_id;
 insert into orders(reference,profile_id,checkout_key,shipping,email,items,subtotal,delivery,total) values('VLT-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,12)),s.profile_id,p_key,p_shipping,customer_email,rows_json,subtotal_value,delivery_value,subtotal_value+delivery_value) returning * into o;
 delete from cart_items where session_id=p_session;
 return to_jsonb(o);
end $$;
revoke all on function public.place_order(uuid,uuid,jsonb) from public,anon,authenticated;
grant execute on function public.place_order(uuid,uuid,jsonb) to service_role;
