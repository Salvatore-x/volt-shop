export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';
import {cookies} from 'next/headers';
import {config,session} from '@/lib/server';
export async function GET(req:Request){if(!config().db||!config().google)return Response.redirect(new URL('/?auth=unavailable',req.url));await session(true);const state=crypto.randomUUID();(await cookies()).set('volt_oauth_state',state,{httpOnly:true,secure:true,sameSite:'lax',path:'/',maxAge:600});const u=new URL('https://accounts.google.com/o/oauth2/v2/auth');u.search=new URLSearchParams({client_id:process.env.GOOGLE_CLIENT_ID!,redirect_uri:`${process.env.APP_URL||new URL(req.url).origin}/api/auth/callback`,response_type:'code',scope:'openid email profile',state,prompt:'select_account'}).toString();return Response.redirect(u);}
