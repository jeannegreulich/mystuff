token=`cat ~/.ssh/AOC-api`

curl "https://jgreulich:${token}@gitlab.tasty.bacon/api/v4/projects/203/repositories"  --cacert /etc/pki/simp/x509/cacerts/cacerts.pem
#curl "https://jgreulich:${token}@gitlab.tasty.bacon/api/v4/projects"  --cacert /etc/pki/simp/x509/cacerts/cacerts.pem
#curl "https://gitlab.tasty.bacon/api/v4/simp/attack-of-the-clones/projects/203/repositories"  --cacert /etc/pki/simp/x509/cacerts/cacerts.pem

