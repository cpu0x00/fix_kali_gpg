targeted issue:

```
The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ED65462EC8D5E4C5
Reading package lists... Done
W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. GPG error: http://mirror.kku.ac.th/kali kali-rolling InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ED65462EC8D5E4C5
W: Failed to fetch http://http.kali.org/kali/dists/kali-rolling/InRelease  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ED65462EC8D5E4C5
W: Some index files failed to download. They have been ignored, or old ones used instead
```


usage:
```
# chmod +x ./fix_kali_gpg.sh
# ./fix_kali_gpg.sh
```
and then let it do its thing
