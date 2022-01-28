help_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

echo "Initial directory structure:"
cat "${help_dir}/demo.dir-struct.txt" | sed 's/^/  /g'

echo
echo "Demo (list):"
cat "${help_dir}/demo.code.ls.txt" | sed 's/^/  /g'

echo
echo "Demo (append):"
cat "${help_dir}/demo.code.append.txt" | sed 's/^/  /g'

echo
echo "Demo (prepend):"
cat "${help_dir}/demo.code.prepend.txt" | sed 's/^/  /g'

echo
echo "Demo (pathfile):"
cat "${help_dir}/demo.code.pathfile.txt" | sed 's/^/  /g'
