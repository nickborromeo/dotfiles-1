function hubbers --description "Fuzzy find through GitHubbers and print out name and recently used email in Co-Authored-By syntax"
  set -l output_dir "$HOME/.tmp/hubbers/cache"
  set -l cached_files (fd . $output_dir -e json 2>/dev/null)

  if test ! -d ".git"
    echo "Must be in git repo!"
    return 1
  end

  if test (count $cached_files) -lt 1
    echo -n "Caching Hubbers"

    if test ! -d $output_dir
      mkdir -p $output_dir
    end

    set -l user (printf "host=github.com\nprotocol=https\n" | git credential-osxkeychain get | grep "username" | sed 's/username=//')
    set -l token (printf "host=github.com\nprotocol=https\n" | git credential-osxkeychain get | grep "password" | sed 's/password=//')

    set -l page 1
    set -l next_url "https://api.github.com/orgs/github/teams/employees/members?per_page=250"
    set -l headers "$output_dir/../gh_headers"

    while test ! -z "$next_url"
      echo -n '.'
      http -a $user:$token $next_url -do "$output_dir/$page.json" -ph 2>$headers

      set next_url (grep "Link:" $headers | tr ',' '\n' | grep "next" | sed 's/.*<\(.*\)>.*/\1/')
      set page (expr $page + 1)
    end
    echo ''
    echo "Done!"

    set cached_files (fd . $output_dir -e json 2>/dev/null)
  end

  set -l coauthor_user (jq --slurp '[.[][]]' $cached_files | jq .[].login | sed 's/"//g' | fzf)
  git log --author=$coauthor_user -n1 --decorate=short | grep "Author" | sed 's/Author: //'
end