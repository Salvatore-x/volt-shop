# VOLT setup

The storefront is deployed in preview mode until Supabase is configured. Preview carts are temporary and never create real orders. The catalog contains fictional products and illustrative photos; replace it with the shop's real products and shipping terms before taking customer orders.

## 1. Supabase
Create a Supabase project. In SQL Editor, run `supabase/schema.sql`, then `supabase/seed.sql`. Do not run the schema twice. Products, profiles, sessions, carts, order items, shipping details, and email status are persisted in Postgres. Tables have RLS enabled and deny all anonymous/authenticated direct access. Only the server-side service role accesses them. The order RPC is executable only by service_role.

Set server secrets `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` in the host environment, not in frontend code. Use the service-role JWT key from Supabase's API settings. No public anon key is needed because Google sign-in is handled directly by this app.

## 2. Google Cloud Console
Create/select a project, configure Google Auth Platform branding and audience, and request only openid/email/profile. If the app remains in testing, add your Google account as a test user. Create an OAuth client of type Web application. Add this exact authorized redirect URI:

https://volt-tech-shop.fsuccess66.chatgpt.site/api/auth/callback

Set `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, and `APP_URL=https://volt-tech-shop.fsuccess66.chatgpt.site` on the host. If moving hosts, update APP_URL and Google's redirect URI together. No Supabase Auth Google provider setup is required: the app exchanges Google's authorization code on the server and reads the verified Google user profile. It uses a one-time state cookie and rotates the opaque session token on login. Tokens in the database are SHA-256 hashes. Session cookies are Secure, HttpOnly, and SameSite=Lax with 30-day expiry.

## 3. Mailgun
Add and verify your sending domain in Mailgun, including required DNS records. For a sandbox domain, authorize the test recipient first. Set `MAILGUN_API_KEY`, `MAILGUN_DOMAIN`, and `MAILGUN_FROM` (for example VOLT <orders@your-verified-domain>). Set `MAILGUN_REGION=EU` for an EU account, otherwise US.

Checkout creates the order atomically and clears the cart before submitting an email. Status `sent` means Mailgun accepted the request, not confirmed inbox delivery. An email error does not undo the order. `pending` means Mailgun is unconfigured. `failed` means a send failed; `sending` may require operator review if a request was interrupted. Before retrying, inspect Mailgun logs to avoid duplicate messages. This build does not include a scheduled email retry worker or delivery webhook.

## Checkout behavior
Google sign-in is required to place orders. Payment is on delivery; no card charge or payment gateway is implemented. Delivery costs NGN 3,500, free from NGN 100,000. All prices and totals come from Postgres, not client input. The transactional RPC locks inventory, checks availability, decrements stock, snapshots prices and delivery information, and saves the order with a unique checkout key so a retry cannot duplicate the same order.

## Verification after connecting
1. Reload the shop: the preview banner disappears and products load from Supabase.
2. Add two products; change quantities; reload and confirm the cart persists.
3. Sign in with the configured Google test user; confirm account information.
4. Complete delivery details and place a test order. Confirm the order exists in Supabase, stock decreased, and the cart is empty.
5. Confirm the Mailgun message and recipient inbox. Check order email_status separately.
6. Open My orders and verify only the signed-in user's orders appear.
7. Test a second Google account, sign-out, stock limits, and mobile checkout.

## Development and deployment
This source uses React, Vinext/Next App Router, and Cloudflare Workers-compatible fetch APIs. Run the package manager's dev/build commands. Runtime values belong in host secrets. The Sites version is owner-private until sharing is changed. A public assignment link and Google redirect flow must be verified after access is enabled. To move to Vercel/Netlify, adapt build settings to their supported Next.js deployment path; do not upload the Cloudflare Worker build as a static site.

## Photo credits
Photos are illustrative, not product claims. Unsplash: headphones (photo-1560718217-69193acc0713), earbuds (photo-1573065371014-a010d4d96d1b), keyboard (photo-1720315631164-d1a79b743f59), speaker (photo-1578487228055-3ce7712d8ff3), mouse (photo-1615663245857-ac93bb7c39e7). Hub photograph from the Cdiscount product listing for tra1705534816519; replace or obtain permission before commercial use.

Reference documentation:
- https://supabase.com/docs/guides/api
- https://supabase.com/docs/guides/database/secure-data
- https://developers.google.com/identity/protocols/oauth2/web-server
- https://developers.google.com/identity/openid-connect/reference
- https://documentation.mailgun.com/docs/mailgun/user-manual/sending-messages/send-http
