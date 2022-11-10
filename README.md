# Tracking your OSS Community Health

This is the open source appendix to our blog post on "Tracking your OSS Community Health". Feel free to submit suggestions, feedback, thoughts, etc.

The repo also includes open source code that allows you to compute the metrics we suggest in the post. I'm a Rubyist myself, so it's in Ruby, but you're welcome to contribute versions in any other language!

# Running the Ruby version

- Make sure you have a Ruby runtime. If you don't, install [rvm](https://rvm.io/)
- Run`mv .env.sample .env` and replace GITHUB_TOKEN with your actual [Github Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- Open `main.rb` and add your team member names to the `TEAM_MEMBER_USERNAMES` if you want to track metrics related to team vs 3rd party work.
- Run `ruby main.rb your/repo_name` to get a full report, or you can spin up an interactive shell with `irb -r ./main.rb`.

# Example Output

```
Analyzing dragonflydb/dragonfly...
Average time to first response for issues: 5.3 days
Average time to close for issues: 6.5 days
Percentage of issues closed after first comment: 24.16%
Average days since last commit on open pull requests: 13.8 days
Percentage of pull requests open more than 30 days: 33.33%
Percentage of reviewed pull requests without follow up: 30.2%
External merged pull requests percentage: 49.19%
Merged pull requests by contributor: {"romange"=>64, "adiholden"=>12, "boazsade"=>23, "dranikpg"=>27, "iko1"=>19, "tamcore"=>5, "zNNiz"=>1, "Super-long"=>3, "lsvmello"=>4, "b0bleet"=>2, "RedhaL"=>2, "ranrib"=>2, "eecheng87"=>1, "JensColman"=>1, "cuishuang"=>1, "gil-air-may"=>1, "YuxuanChen98"=>1, "matchyc"=>1, "inohime"=>2, "ATM-SALEH"=>1, "logandk"=>1, "odedponcz"=>13, "acheevbhagat"=>2, "Tomato6966"=>1, "ryanrussell"=>12, "braydnm"=>3, "eltociear"=>1, "shmulik-klein"=>2, "jbylund"=>1, "romgrk"=>1, "zacharya19"=>4, "lucagoslar"=>1, "Ansore"=>1, "alisaifee"=>4, "shuuji3"=>1, "quiver"=>1, "olleolleolle"=>2, "jherdman"=>1}
```
