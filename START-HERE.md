# VOLT source handover

This is the current working Sites/Cloudflare source, commit 86e8811f39ce5f183578c6d58830d0d69a670d08. It includes the name display and Sign in / Sign up changes.

## Push to your GitHub account
Extract this ZIP. Create an empty GitHub repository, open a terminal in the extracted volt-shop folder and run:

```sh
git init
git add .
git commit -m "Initial VOLT shop source"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/volt-shop.git
git push -u origin main
```

Replace YOUR-USERNAME with your GitHub username. This export does not include Git history, node_modules, build output, database contents, or secret credentials.

## Hosting status
The existing shop is already hosted on Sites. This ZIP is source code, not a Netlify-ready static deployment. Its build currently targets Cloudflare through Vinext. Before deploying on Netlify, adapt the project to Netlify's supported Next.js runtime, build it, and test its API routes. Prefer connecting the GitHub repository for deployment.

Set these values privately on the new host: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, APP_URL, MAILGUN_API_KEY, MAILGUN_DOMAIN, MAILGUN_FROM, MAILGUN_REGION.
Set APP_URL to the new HTTPS origin and add that origin plus /api/auth/callback as an authorized Google OAuth redirect URI. Never put secret values in GitHub or client-side variables.

Reuse the existing Supabase database to preserve products and orders. Do not rerun its schema or seed scripts during a host migration. Those scripts are for a fresh database only.

Google sign-in, database persistence, and a sandbox confirmation email have been tested on the existing host. This export has not been tested on Netlify. Payments remain pay-on-delivery. Mailgun sandbox only sends to authorized recipients. No admin dashboard or live payment gateway is included.
