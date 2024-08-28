# How to create GitHub Actions Secrets

1. **Go to the `Settings` section of your forked repository**

![GitHub Actions Secret 1](png_files/github_actions_secrets1.png)

2. **Scroll down. Look for `Secrets and Variables` in the `Security` section of the left pane. Select it, then select `Actions`**

![GitHub Actions Secret 2](png_files/github_actions_secrets2.png)

3. **In the `Actions Secrets and Variable` page, scroll down and select `New Repository Secret`**

![GitHub Actions Secret 3](png_files/github_actions_secrets3.png)
![GitHub Actions Secret 4](png_files/github_actions_secrets4.png)

4. **For the first secret, add in the password that you will use to encrypt the [secrets.yaml](../secrets.yaml) file. Name the secret `ANSIBLE_VAULT_PASSWORD` and put in the password (no quotes. just plain text). Make sure to write it down so that you will remember it when you need to encrypt the file in your terminal before `git add`.**

![GitHub Actions Secret 5](png_files/github_actions_secrets5.png)

5. **Follow the same format to create the rest of the secrets except `AZURE_CREDENTIALS`. Makes sure their names are set exactly as they are in the screenshot that shows all repository secrets, so that the workflow scripts can find them**

![GitHub Actions Secret 6](png_files/github_actions_secrets6.png)
![GitHub Actions Secret 7](png_files/github_actions_secrets7.png)

6. **For the `AZURE_CREDENTIALS` secrets, follow this format**
![GitHub Actions Secret 8](png_files/github_actions_secrets8.png)
