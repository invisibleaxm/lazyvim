# Neovim VSCode Integration Test

## Test 1: Is Neovim Mode Active?
- [ ] Look at **bottom-left status bar** → Should show `-- NORMAL --` or `-- INSERT --`
- [ ] If NOT showing → Press `Ctrl+Shift+P` → type "Neovim: Toggle" → Enable it

## Test 2: Basic Vim Motions
Try these in order:
1. Press `Esc` to ensure you're in NORMAL mode
2. Press `j` → Cursor should move DOWN ✅
3. Press `k` → Cursor should move UP ✅
4. Press `h` → Cursor should move LEFT ✅
5. Press `l` → Cursor should move RIGHT ✅

**If motions don't work:** Neovim mode is not active!

## Test 3: Yank and Paste
1. Press `Esc` to enter NORMAL mode
2. Move cursor to any line
3. Press `yy` → Line should be yanked (might see brief highlight)
4. Move cursor down one line (press `j`)
5. Press `p` → Line should paste BELOW cursor
6. Press `u` to undo
7. Press `P` (capital P) → Line should paste ABOVE cursor

## Test 4: Visual Selection and Paste
1. Press `v` to enter VISUAL mode → Status bar shows `-- VISUAL --`
2. Press `j` a few times to select lines → Text highlights
3. Press `y` to yank → Selection copied
4. Press `p` to paste → Should paste the selection

## Test 5: Alternative Paste (Leader Key)
If normal `p` doesn't work, try:
1. Yank a line with `yy`
2. Press `<Space>p` (space then p) → Uses custom paste binding

## Common Issues

### Issue 1: Neovim Not Starting
**Check Output Panel:**
- Press `Ctrl+Shift+U` (Output panel)
- Select dropdown: **"Neovim"**
- Look for errors like "spawn ENOENT" or "Failed to start"

**If you see errors:** Share them with me!

### Issue 2: `p` Types the Letter 'p'
This means you're in **INSERT mode** not NORMAL mode:
- Press `Esc` to return to NORMAL mode
- Status bar should show `-- NORMAL --`
- Now try `p` again

### Issue 3: Nothing Happens When Pressing `p`
This could be:
1. **Clipboard issue:** Try `"*p` (star register paste) or `"+p` (plus register paste)
2. **Register empty:** Make sure you successfully yanked with `yy` first
3. **Keybinding conflict:** Check if VSCode captured the key

### Issue 4: Can't See Status Bar
The status bar shows Neovim mode at **bottom-left corner**:
```
-- NORMAL --    ← Should see this
-- INSERT --    ← Or this when in insert mode
-- VISUAL --    ← Or this in visual mode
```

If not visible → Extension is not active!

## Quick Verification Script

Copy these lines and try the paste test:
```
Line 1: Test line for yanking
Line 2: Another test line
Line 3: Final test line
```

1. Put cursor on "Line 1"
2. Press `yy`
3. Press `j` to move down
4. Press `p`
5. Expected result: "Line 1" appears below "Line 2"

## VSCode Commands to Try

Press `Ctrl+Shift+P` and try these:

1. **Neovim: Show Output** → Check for errors
2. **Neovim: Toggle** → Enable/disable mode
3. **Neovim: Restart** → Restart Neovim instance

## Report Back

Please test the above and tell me:
1. ✅ or ❌ for each test
2. What you see in the status bar
3. Any errors from Output panel (Ctrl+Shift+U → select "Neovim")
