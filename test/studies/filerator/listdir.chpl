use Filerator, Sort;

config const startdir = "subdir";
config const recur = false;
config const dotfiles = false;
config param sort = true;

if sort then
  for filename in sorted(listdir(startdir, recur, dotfiles, nosvn=true)) do
    writeln(filename);
else
  for filename in listdir(startdir, recur, dotfiles, nosvn=true) do
    writeln(filename);
