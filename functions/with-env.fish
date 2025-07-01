function with-env --description "Run command with environment variables from .env file"
    if test -f .env
        env (cat .env | grep -v "#" | string replace -r '^' '' | string replace -r '=' ' ') $argv
    else
        echo "No .env file found in current directory"
        return 1
    end
end