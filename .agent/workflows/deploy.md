---
description: How to release a new version of feda_flutter to pub.dev
---

## Release Checklist

### 1. Prepare the release

1. Make sure you are on the `dev` branch and it's up to date
   ```bash
   git checkout dev && git pull
   ```

2. Merge your feature branch into `dev`
   ```bash
   git merge feat/your-feature
   ```

3. Update `CHANGELOG.md` — add a section for the new version:
   ```markdown
   ## 0.1.0

   * Your change description here.
   ```

4. Bump the version in `pubspec.yaml`:
   ```yaml
   version: 0.1.0
   ```

5. Run checks locally:
   ```bash
   flutter analyze .
   flutter test
   ```

6. Merge `dev` into `main`:
   ```bash
   git checkout main && git merge dev
   ```

### 2. Tag & push (triggers GitHub Release automatically)

// turbo
7. Create and push the version tag:
   ```bash
   git tag v0.1.0 && git push origin main --tags
# or 
   git tag v0.2.0
   git push origin v0.2.0
   ```
   → GitHub Actions will extract the `CHANGELOG.md` section and create a GitHub Release automatically.
   → The changelog site will update live.

### 3. Publish to pub.dev

8. Dry-run first:
   ```bash
   dart pub publish --dry-run
   ```

9. Publish:
   ```bash
   dart pub publish
   ```