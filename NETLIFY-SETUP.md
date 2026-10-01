# Deploy VOLT on Netlify

Copy the contents of this update folder into your existing volt-shop repository, merging folders and replacing matching files. Keep your .git folder. No keys are included.

Commit and push:
```sh
git add .
git commit -m "Adapt VOLT for Netlify"
git push
```

In Netlify, import the Salvatore-x/volt-shop GitHub repository. Use branch main, an empty base directory, build command `pnpm run build`, publish directory `.next`. The netlify.toml file supplies these settings. Netlify automatically handles Next.js server routes; do not use static export or deploy only the public folder.

This update uses standard Next.js instead of the previous Cloudflare build. Existing dependencies and lockfile are preserved. The old Sites/Vinext helper files are unused by this build.

Add these environment variables in Netlify with Functions/runtime access (or all scopes):
- SUPABASE_URL: existing Supabase project URL
- SUPABASE_SERVICE_ROLE_KEY: existing secret server key
- GOOGLE_CLIENT_ID: existing Google OAuth web client ID
- GOOGLE_CLIENT_SECRET: existing Google OAuth secret
- APP_URL: exact new https://YOUR-SITE.netlify.app origin, without trailing slash
- MAILGUN_API_KEY: saved domain sending key
- MAILGUN_DOMAIN: your Mailgun sending domain
- MAILGUN_FROM: your Mailgun sender address
- MAILGUN_REGION: US

Keep secrets out of Git. Reuse the existing Supabase database: do not rerun schema or seed scripts. Once Netlify assigns a domain, add https://YOUR-SITE.netlify.app/api/auth/callback to the existing Google OAuth client's authorized redirect URIs. Keep the old URI if you still use the Sites version. Redeploy after saving environment variables.

The Netlify site will have a new session cookie, so sign in again. Test product loading, cart persistence, Google sign-in, checkout, order history, and email delivery. Mailgun sandbox still only sends to authorized recipients. Payment remains pay on delivery.

Validation: standard Next.js production build and TypeScript passed; local production pages and preview API responded successfully; invalid-origin mutation rejected. Live Supabase/Google/Mailgun integration must be tested on the new Netlify URL after configuration. No Netlify deployment has been performed yet.
