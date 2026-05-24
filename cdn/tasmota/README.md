# Tasmota CDN UI Assets

Upload these files to:

- `https://assets.cossth.com/tasmota/styles.css`
- `https://assets.cossth.com/tasmota/script.js`

## Files

- `styles.css`: Modern UI theme for stock Tasmota pages
- `script.js`: Runtime enhancer that adds classes/effects and handles AJAX refresh content

## Notes

- No firmware HTML template edits are required.
- Your firmware is already configured to load these URLs via:
  - `EXTERNAL_WEB_CSS_URL`
  - `EXTERNAL_WEB_JS_URL`
- If changes do not appear immediately, hard refresh browser cache (`Ctrl+F5`) or append a query string in firmware, e.g. `styles.css?v=2`.

## Safe fallback

If CDN is unavailable, Tasmota still loads with default built-in styling and behavior.
