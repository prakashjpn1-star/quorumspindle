# Browser journeys

The browser controls and explains real engine state. It is an implementation deliverable, not a simulated dashboard.

## Basic browser UI

Provide local HTML, CSS, and JavaScript, with optional locally compiled TypeScript. No CDN, external fonts, analytics, or online login.

Required screens: cluster overview; node/log inspection; key read/CAS playground; directed partition controls; scenario runner; and report viewer. Display terms and indices beside role labels so users can understand delayed information. Separate committed entries from pending entries. Show an unknown client outcome as unknown.

All destructive lab actions identify affected test nodes. Controls need keyboard access, visible error states, disabled/busy behavior, and confirmation for deleting a test dataset. Polling must be bounded and must not become benchmark traffic unless explicitly selected.
