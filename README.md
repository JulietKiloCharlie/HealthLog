# Fiadh's Care Diary — GitHub Pages + Supabase

Project: `JulietKiloCharlie/HealthLog`  
Site (after enabling Pages): https://julietkilocharlie.github.io/HealthLog/

## Before sharing the link

1. Open your Supabase project: https://supabase.com/dashboard/project/ojrcsrkplytmnhdvdmrw
2. **Already completed:** You reported successfully running `supabase-setup.sql`. No need to run it again.
3. **Already completed:** You reported creating two parent accounts. Check that both email addresses are confirmed and each parent has their own password. Do not share passwords.
4. **Already completed:** You reported adding both parent emails to `care_members`. No need to run the insert again.

5. **Already completed:** `config.js` contains the project URL and browser-safe Supabase publishable key. No editing needed. **Never use `service_role` or a secret key in the website.**
6. Upload `index.html`, `app.js`, `config.js` to the root of the GitHub `HealthLog` repository (the SQL and README may also be committed, but don't commit real medical records, passwords or secrets).
7. On GitHub, open **Settings → Pages → Build and deployment**, select **Deploy from a branch**, branch **main**, folder **/(root)**, and save. The site will be at https://julietkilocharlie.github.io/HealthLog/ once GitHub finishes deploying.
8. Test using the two separate accounts in two different browsers/phones: sign in, add a **dummy** temperature, confirm it appears on the other device, record a **dummy** medication entry and save its follow-up. Remove test entries in the Supabase Table Editor before real use.
9. Confirm that a signed-out browser cannot see the records and that an account **not** in `care_members` cannot read or write entries. Do not enter real child health data until those tests pass.

## What works

- Separate email/password logins; database Row Level Security limits reads and writes to two explicitly approved verified accounts.
- Shared live records; Supabase Realtime refreshes the diary on changes, and reopening the page reloads current data.
- Temperature readings, medication name/strength/amount/time, wellbeing, 60-minute follow-up check, and before/after comparison.
- Temperature trend and CSV/JSON export.

## Important limitations

- **No background push notifications**: the 60-minute check appears in the diary, including if overdue, but it does not ring when the phone is locked or the page is closed.
- The 60-minute checkpoint is a reminder to **reassess**, not a recommended repeat-dose interval or proof of treatment effectiveness.
- No automated dose recommendations, medication-interaction checking or medical decision-making. Verify the bottle and any clinician instructions independently.
- Entries use the selected 'Added by' label. The database also stores the authenticated account ID (`created_by`), but the interface doesn't yet display it.
- Entries are capped at the latest 1,000 in the app; export is limited to those loaded entries.
- Realtime refreshes the current view and may interrupt an in-progress follow-up form; save promptly.
- The static website files are public on GitHub Pages. Only the diary *data* is protected by Supabase Auth/RLS. Keep names, private notes and any real records out of the repository.
- A separate clinical review is appropriate for any concerning symptoms. This is a logging aid, not medical advice.

## Troubleshooting

- 'Setup required': the key is still a placeholder in `config.js`.
- Sign-in fails: verify Supabase Auth account, email confirmation, and password.
- Diary appears empty or updates fail: check `care_members` for exact lowercase verified email addresses and run the RLS SQL.
- Updates do not appear immediately on the other phone: refresh; confirm Realtime publication is enabled for `care_entries`.
