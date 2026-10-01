# VOLT gadget update

This adds eight fictional demo products, product illustrations, automatic category filters, and wrapping category buttons. Prices, stock, and specifications are sample data, not verified inventory.

1. Copy the app, components, lib, public, and supabase folders from this package into your existing volt-shop repository. Merge folders and replace matching files. Keep your existing project folder and .git directory.
2. In your repository terminal run:

```sh
git add app/globals.css components/shop.tsx lib/catalog.ts public/products supabase/add-gadgets.sql
git commit -m "Expand gadget catalogue and category filters"
git push origin main
```

3. Wait for the Netlify deployment to be Published before adding database rows, so the new image files are available.
4. Open your existing Supabase project → SQL Editor → New query. Paste the contents of supabase/add-gadgets.sql and run it. Do not rerun schema.sql or the original seed.sql. The new SQL only inserts missing product IDs.
5. Refresh the shop. A previously unchanged catalogue should now contain 14 products, including Gaming and Wearables. Try category filters, search, a product page, and adding a new item to your bag. Place one test order if desired to verify checkout and email.

No environment variable or Google callback changes are needed. No payment, authentication, email, or checkout code is changed. This package does not include credentials.
