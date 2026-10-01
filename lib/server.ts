import { cookies } from 'next/headers';
export const config=()=>({db:!!(process.env.SUPABASE_URL&&process.env.SUPABASE_SERVICE_ROLE_KEY),google:!!(process.env.GOOGLE_CLIENT_ID&&process.env.GOOGLE_CLIENT_SECRET),mail:!!(process.env.MAILGUN_API_KEY&&process.env.MAILGUN_DOMAIN&&process.env.MAILGUN_FROM)});
export class ShopError extends Error { constructor(public code:string,message:string){super(message);this.name='ShopError';} }
export async function db(path:string,method='GET',body?:unknown){
 if(!config().db) throw new Error('The shop is not connected yet. Orders are currently unavailable.');
 const key=process.env.SUPABASE_SERVICE_ROLE_KEY!.trim();
 let base:URL;
 try{base=new URL(process.env.SUPABASE_URL!.trim());}catch{throw new ShopError('DATABASE_URL_INVALID','The database URL needs to be corrected in the shop settings.');}
 if(base.protocol!=='https:'||!base.hostname.endsWith('.supabase.co')||base.pathname!=='/')throw new ShopError('DATABASE_URL_INVALID','Use the Supabase project URL, not the dashboard address, in the shop settings.');
 const headers:Record<string,string>={apikey:key,'Content-Type':'application/json',Prefer:'return=representation,resolution=merge-duplicates'};
 if(!key.startsWith('sb_secret_'))headers.Authorization=`Bearer ${key}`;
 let r:Response;
 try{r=await fetch(`${base.origin}/rest/v1/${path}`,{method,headers,body:body===undefined?undefined:JSON.stringify(body)});}catch{throw new ShopError('DATABASE_CONNECTION_FAILED','The database connection failed. Please check the connection settings.');}
 if(!r.ok){let code='';try{const detail:any=await r.json();if(typeof detail.code==='string'&&/^[A-Z0-9_]{1,30}$/.test(detail.code))code=detail.code;}catch{}
 console.error('Database request failed',{status:r.status,code,resource:path.split('?')[0]});
 if(r.status===401)throw new ShopError('DATABASE_KEY_REJECTED','The database rejected the server key. Please check the saved Supabase key.');
 if(r.status===403)throw new ShopError('DATABASE_ACCESS_DENIED','The database permissions need checking.');
 throw new ShopError('DATABASE_REQUEST_FAILED','We could not load or save your changes. Please try again.');}
 const t=await r.text();return t?JSON.parse(t):null;
}
export async function hash(v:string){return Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',new TextEncoder().encode(v)))).map(b=>b.toString(16).padStart(2,'0')).join('');}
export async function session(create=false){const c=await cookies();const t=c.get('volt_session')?.value;
 if(t){const rows=await db(`shop_sessions?token_hash=eq.${await hash(t)}&expires_at=gt.${encodeURIComponent(new Date().toISOString())}&select=*`);if(rows[0])return rows[0];}
 if(!create)return null;const token=crypto.randomUUID()+crypto.randomUUID();const rows=await db('shop_sessions','POST',{token_hash:await hash(token),expires_at:new Date(Date.now()+30*86400000).toISOString()});c.set('volt_session',token,{httpOnly:true,secure:true,sameSite:'lax',path:'/',maxAge:30*86400});return rows[0];}
export function checkOrigin(req:Request){const origin=req.headers.get('origin');const expected=process.env.APP_URL||new URL(req.url).origin;if(!origin||origin!==expected)throw new Error('Please refresh the page and try again.');}
export async function sendConfirmation(order:any){
 if(!config().mail)return 'pending';
 const claimed=await db(`orders?id=eq.${order.id}&email_status=eq.pending`,'PATCH',{email_status:'sending'});if(!claimed.length)return order.email_status;
 try{const form=new FormData();form.set('from',process.env.MAILGUN_FROM!);form.set('to',order.email);form.set('subject',`Your VOLT order ${order.reference}`);form.set('text',`Thanks for shopping with VOLT, ${order.shipping.name}!\n\nOrder: ${order.reference}\n${order.items.map((i:any)=>`${i.name} × ${i.quantity}: NGN ${i.price*i.quantity}`).join('\n')}\nDelivery: NGN ${order.delivery}\nTotal: NGN ${order.total}\nPayment: Pay on delivery\n\nDeliver to: ${order.shipping.address}, ${order.shipping.city}, ${order.shipping.state}\n\nYour order has been received.`);
 const r=await fetch(`https://${process.env.MAILGUN_REGION==='EU'?'api.eu.mailgun.net':'api.mailgun.net'}/v3/${process.env.MAILGUN_DOMAIN}/messages`,{method:'POST',headers:{Authorization:`Basic ${btoa('api:'+process.env.MAILGUN_API_KEY)}`},body:form});if(!r.ok)throw new Error('Email rejected');await db(`orders?id=eq.${order.id}`,'PATCH',{email_status:'sent'});return 'sent';
 }catch{await db(`orders?id=eq.${order.id}`,'PATCH',{email_status:'failed'});return 'failed';}
}
