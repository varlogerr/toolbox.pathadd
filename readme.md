# Pathadd tool

Manage PATH in a smarter way. Pathes added with this tool ensure uniqueness of PATH entries (unless `--force` flag is used)

## Installation

```sh
# clone the repository
sudo git clone https://github.com/varlogerr/toolbox.pathadd.git /opt/varlog/toolbox.pathadd
# add bash hook
echo '. /opt/varlog/toolbox.pathadd/hook.bash' >> ~/.bashrc
# reload ~/.bashrc
. ~/.bashrc
# expore the script
pathadd.help
```
