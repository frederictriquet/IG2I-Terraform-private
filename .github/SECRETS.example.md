# GitHub Secrets Configuration

This file shows how to configure secrets for the mirror synchronization workflow.

## Required Secrets

Go to **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### 1. MIRROR_REPO_URL

**Description**: SSH URL of the mirror/student repository

**Value example**:
```
git@github.com:YOUR_ORG/terraform-training-students.git
```

**How to get it**:
1. Create the mirror repository on GitHub
2. Copy the SSH URL from the repository page

---

### 2. MIRROR_SSH_KEY

**Description**: SSH private key for accessing the mirror repository

**How to generate**:

```bash
# Generate a dedicated SSH key pair
ssh-keygen -t ed25519 -C "mirror-bot@github-actions" -f ~/.ssh/mirror_key -N ""

# Display the private key (copy this to the secret)
cat ~/.ssh/mirror_key
```

**Value**: The entire content of the private key file, including:
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
...
-----END OPENSSH PRIVATE KEY-----
```

**Deploy Key Setup**:

After creating this secret, add the PUBLIC key to the mirror repository:

1. Display the public key:
   ```bash
   cat ~/.ssh/mirror_key.pub
   ```

2. Go to the **mirror repository** → **Settings** → **Deploy keys** → **Add deploy key**
3. Title: `Mirror Sync Bot`
4. Key: Paste the public key content
5. ✅ **Check "Allow write access"**
6. Click "Add key"

---

### 3. MIRROR_BRANCH (optional)

**Description**: Target branch in the mirror repository

**Default**: `master`

**Value example**:
```
main
```

Only set this if your mirror repository uses a different default branch.

---

## Security Notes

- The SSH key should be **dedicated** to this mirroring task only
- Use ED25519 keys (more secure and faster than RSA)
- Never commit private keys to the repository
- Rotate keys periodically (every 6-12 months)
- Limit the deploy key to write access on the mirror repo only

## Verification

After configuring secrets, test the workflow:

1. Go to **Actions** → **Mirror Sync to Student Repository**
2. Click **Run workflow**
3. Select branch `master`
4. Click **Run workflow**
5. Monitor the execution logs

Expected output:
```
✅ Mirror synchronization completed successfully
Mirror repository has been updated with latest changes (excluding solutions)
```

## Troubleshooting

### "Permission denied (publickey)"

- Verify the private key is complete in `MIRROR_SSH_KEY`
- Ensure the public key is added as a deploy key with write access
- Check there are no extra spaces or newlines in the secret

### "Repository not found"

- Verify `MIRROR_REPO_URL` is correct
- Ensure you're using SSH format (`git@github.com:...`) not HTTPS
- Check the deploy key has access to the repository

### "No changes to sync"

This is normal if there are no actual changes. The workflow only commits when files differ.
