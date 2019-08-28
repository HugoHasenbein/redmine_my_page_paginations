# redmine_my_page_pagination

Redmine plugin to add pagination links to my page queries

### Use case(s)

* Redmine's current My Page only shows rigid 10 line queries. This plugin adds pagination links to queries. It honors setting in Administration->Settings->General->Object per page options

![PNG that represents a quick overview](/doc/my_page_example.png)

### Install

1. download plugin and copy plugin folder redmine_my_page_pagination to Redmine's plugins folder 

2. restart server f.i.  

`sudo /etc/init.d/apache2 restart`

(no migration is necessary)

### Uninstall

1. go to plugins folder, delete plugin folder redmine_my_page_pagination

`rm -r redmine_tint_issues`

2. restart server f.i. 

`sudo /etc/init.d/apache2 restart`

### Use

* Go to MyPage, select your issue query from the "Add" menu. The query will have pagination links if number of items in list exceeds minimum object per page

**Have fun!**

### Localisations

* 1.0.2
  - English
  - German

### Change-Log* 

**1.0.2**
 - cleaned code, minor bug fixes
 
**1.0.1**
 - cleaned code
 
**1.0.0** 
  - running on Redmine 3.4.6, 3.4.11
