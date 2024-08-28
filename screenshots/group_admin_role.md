# How to assign Groups Administrator Role

1. **In the Azure Portal, search for Entra Roles**

![Entra Role Search 1](png_files/search_entra_role1.png)

2. **Click on Microsoft Entra Roles and Administrators**

![Entra Role Search 2](png_files/search_entra_role2.png)

3. **Search for Groups Administrator and click on it**

![Group Admin Role Search](png_files/find_group_admin_role.png)

4. **Click on Add Assignment**

![Add Assignment 1](png_files/add_assignment1.png)

5. **Search for your newly created Service Principal called capstone_service_principal (except you changed the name or did not run the [service_principal.sh](../service_principal.sh) bash script properly, you should see it). Select it and add it (Ignore that it is called GitHub Actions here. You are looking for capstone_service_principal).**

![Entra Role Search 1](png_files/add_assignment2.png)

6. **It should show up like this when you have added it. You can move on to the next step.**

![Entra Role Search 1](png_files/add_assignment3.png)
