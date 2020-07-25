## Ldap autentication with R 
https://stackoverflow.com/questions/22793855/how-do-i-run-a-ldap-query-using-r

## Online ldap server for testing 
1. https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/

2. https://www.zflexldapadministrator.com/index.php/blog/82-free-online-ldap

## R pck to search ldap server servers
https://github.com/LukasK13/ldapr/blob/master/R/ldapr.R

## test R con 
```
require('RCurl')

ldap_server <- 'www.zflexldap.com:389'
pwd <- 'zflexpass'
getURL(ldap_server, userpwd = pwd)
getURL(ldap_server, .opts=list(userpwd = pwd))



ldap_server <- 'ldap.forumsys.com:389'
pwd <- 'password'

getURL(ldap_server, userpwd = pwd)
getURL(ldap_server, .opts=list(userpwd = pwd))

```



curl -u DOMAIN\\MYACCOUNT:MYPASSWORD   \
 "ldap://dc.redaelli.org:3268/OU=users,DC=redaelli,DC=org?memberOf,sAMAccountName?sub?(sAMAccountName=matteo)"


curl -u ldap.forumsys.com:389\\gauss:password   "ldap://ldap.forumsys.com:389/OU=mathematicians,DC=example,DC=com?memberOf,sAMAccountName?sub?(sAMAccountName=gauss)"



---------------------------------------------------------------------------

"ldap://ldap.forumsys.com/DC=example,DC=com", "example\\euler", "password"

"ldap://ldap.forumsys.com/OU=mathematicians,DC=example,DC=com", "example\\euler", "password"
"ldap://ldap.forumsys.com/OU=mathematicians,DC=example,DC=com", "example\\euler", "password"




Bind DN: cn=read-only-admin,dc=example,dc=com
Bind Password: password

All user passwords are password.



You may also bind to individual Users (uid) or the two Groups (ou) that include:

ou=mathematicians,dc=example,dc=com

riemann
gauss
euler
euclid

ou=scientists,dc=example,dc=com
einstein
newton
galieleo
tesla


## ldap utils 
sudo apt-get install ldap-utils

ldapwhoami -vvv -h <hostname> -p <port> -D <binddn> -x -w <passwd>

ldapwhoami -vvv -h ldap.forumsys.com -p 389 -D "cn=read-only-admin,dc=example,dc=com" -x -w password
ldapwhoami -vvv -h ldap.forumsys.com -p 389 -D "uid=riemann,dc=example,dc=com" -x -w password



getURL("ldap://ldap.replaceme.com/o=replaceme.com?memberuid?sub?(cn=group-name)")
getURL("ldap://ldap.forumsys.com/o=forumsys.com?memberuid?sub?(cn=scientists)")








```
library(RCurl)
library(gtools)

parseldap<-function(url, userpwd=NULL)
{
  ldapraw<-getURL(url, userpwd=userpwd)
  # seperate by two new lines
  ldapraw<-gsub("(DN: .*?)\n", "\\1\n\n", ldapraw)
  ldapsplit<-strsplit(ldapraw, "\n\n")
  ldapsplit<-unlist(ldapsplit)
  # init list and count
  mylist<-list()
  count<-0
  for (ldapline in ldapsplit) {
    # if this is the beginning of the entry
    if(grepl("^DN:", ldapline)) {
      count<-count+1
      # after the first 
      if(count == 2 ) {
        df<-data.frame(mylist)
        mylist<-list()
      }
      if(count > 2) {
        df<-smartbind(df, mylist)
        mylist<-list()
      }
      mylist["DN"] <-gsub("^DN: ", "", ldapline)
    } else {
      linesplit<-unlist(strsplit(ldapline, "\n"))
      if(length(linesplit) > 1) {
        for(line in linesplit) {
          linesplit2<-unlist(strsplit(line, "\t"))
          linesplit2<-unlist(strsplit(linesplit2[2], ": "))
          if(!is.null(unlist(mylist[linesplit2[1]]))) {
            x<-strsplit(unlist(mylist[linesplit2[1]]), "|", fixed=TRUE)

            x<-append(unlist(x), linesplit2[2])
            x<-paste(x, sep="", collapse="|")
            mylist[linesplit2[1]] <- x
          } else {
            mylist[linesplit2[1]] <- linesplit2[2]  
          }
        }
      } else {
        ldaplinesplit<-unlist(strsplit(ldapline, "\t"))
        ldaplinesplit<-unlist(strsplit(ldaplinesplit[2], ": "))
        mylist[ldaplinesplit[1]] <- ldaplinesplit[2]
      }

    }

  }
  if(count == 1 ) {
    df<-data.frame(mylist)
  } else {
    df<-smartbind(df, mylist)
  }
  return(df)
}
``` 








require(stringr)

query_ldap <- function(ldap_server,  ldap_port, ldap_user, ldap_pwd, ldap_dc) {
  
    

  ldap_dc <-  str_split(ldap_dc, '\\.')[[1]]
  ldap_dc <- paste0('"uid=',ldap_user,',dc=', ldap_dc[[1]], ',dc=', ldap_dc[[2]], '"'  )
  
  
  ldap_cmd <- paste ( 'ldapwhoami -vvv -h ',  ldap_server, '-p ' , ldap_port , '-D ',  ldap_dc, ' -x -w ',  ldap_pwd)
  
  
  ldap_return  <- system(ldap_cmd, intern = T)
  
  ldap_auth <- 1
  
  if (length(ldap_return) == 2) {
    if (ldap_return[[2]] == 'Result: Success (0)') {
      ldap_auth <- 0
    }
  }
  
 ldap_auth
}

  
query_ldap( ldap_server = 'ldap.forumsys.com',
            ldap_port = '389',
            ldap_user = 'riemann',
            ldap_pwd = 'password',
            ldap_dc = 'example.com')

  

