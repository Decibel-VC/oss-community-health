# rubocop: disable all

require 'dotenv/load'

require 'octokit'

# Create a class GithubHealth with method get_issues that uses Octokit to get all issues for a repository
class GithubHealth
  TEAM_MEMBER_USERNAMES = %w[
    
  ].freeze

  def initialize
    @client_object = Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'), page_size: 100)
  end

  def client
    if @client_object.rate_limit.remaining < 10
      puts "Sleeping for #{@client_object.rate_limit.resets_in} seconds to reset rate limit"
      sleep(@client_object.rate_limit.resets_in) 
    end

    @client_object
  end

  ##
  ## These methods cover the "#1: Open a Github issue with a bug report / feature idea" section of the post
  ##

  def external_issues_percentage(repo, options = {})
    if TEAM_MEMBER_USERNAMES.empty?
      puts "Note: skipping external issues % calculation as TEAM_MEMBER_USERNAMES is empty"
      return 0      
    end

    issues = issues_for_repo(repo, { state: 'open' }.merge(options)) # We don't want to track closed historical issues as they are likely going to skew this

    internal_issues = issues.select { |issue| TEAM_MEMBER_USERNAMES.map(&:downcase).include?(issue.user.login.downcase) }
    external_issues = issues - internal_issues

    external_issues.count.to_f / issues.count
  end

  def time_to_first_response_for_issues(repo, options = {})
    issues = issues_for_repo(repo, { state: 'all' }.merge(options)) # We want to track this historically, not just open issues

    first_response_times = issues.map do |issue|
      issue_comments = client.issue_comments(repo, issue.number)
      issue_comments.map do |comment|
        comment.created_at - issue.created_at
      end.min
    end.compact

    # Return the average time to first response in days (60 * 60 * 24)
    (first_response_times.sum.to_f / first_response_times.count) / (86_400)
  end

  def time_to_close_for_issues(repo, options = {})
    issues = issues_for_repo(repo, { state: 'all' }.merge(options)) # We want to track this historically, not just open issues

    close_times = issues.map do |issue|
      next unless issue.closed_at # only track closed ones

      issue.closed_at - issue.created_at
    end.compact

    # Return the average time to first response in days (60 * 60 * 24)
    (close_times.sum.to_f / close_times.count) / (86_400)
  end

  def issues_closed_after_first_comment(repo, options = {})
    issues = issues_for_repo(repo, { state: 'closed' }.merge(options)) # We want to track this historically, not just open issues

    # We are only looking at closed issues, so we just need to check that comment = 1
    closed_issues = issues.select do |issue|
      issue.comments == 1
    end

    closed_issues.count.to_f / issues.count
  end

  ##
  ## These methods cover the "#2: Make the changes to the codebase" section of the post
  ##

  def days_since_last_commit_of_pull_requests(repo, options = {})
    pull_requests = pull_requests_for_repo(repo, { state: 'open' }.merge(options))

    days_since_last_commit = pull_requests.map do |pull_request|
      client.pull_request_commits(repo, pull_request.number).map do |commit|
        Time.now - commit.commit.committer.date
      end.min
    end.compact

    # Return the average time to first response in days (60 * 60 * 24)
    (days_since_last_commit.sum.to_f / days_since_last_commit.count) / (86_400)
  end

  def pull_requests_open_more_than_30_days(repo, options = {})
    pull_requests = pull_requests_for_repo(repo, { state: 'open' }.merge(options)) # We want to track this historically, not just open pull requests

    more_than_30_days_old = pull_requests.select do |pull_request|
      Time.now - pull_request.created_at > (86_400 * 30)
    end
    
    more_than_30_days_old.count.to_f / pull_requests.count
  end

  ##
  ## These methods cover the "#3: Ask for a PR review + merge" section of the post
  ##

  def reviewed_pull_requests_without_follow_on(repo, options = {})
    pull_requests = pull_requests_for_repo(repo, { state: 'all' }.merge(options)) # We want to track this historically, not just open pull requests

    no_follow_ups = 0

    pull_requests.each do |pull_request|
      reviews = client.pull_request_reviews(repo, pull_request.number, options)
      
      if reviews.empty?
        no_follow_ups += 1
        next 
      else
        last_review = reviews.last

        next if last_review.state == 'APPROVED' # If the PR was merged, we don't need additional comments
        
        review_sent_at = reviews.last.submitted_at
        
        last_commit = client.pull_request_commits(repo, pull_request.number).last
        last_commit_date = last_commit.commit.committer.date

        review_sent_at > last_commit_date ? no_follow_ups += 1 : next
      end
    end

    no_follow_ups.to_f / pull_requests.count
  end

  def merged_pull_requests_by_contributor(repo, options = {})
    pull_requests = pull_requests_for_repo(repo, { state: 'closed' }.merge(options))

    merged_pull_requests = pull_requests.select { |pull_request| pull_request.merged_at }

    merged_pull_requests_by_contributor = merged_pull_requests.group_by { |pull_request| pull_request.user.login }

    merged_pull_requests_by_contributor.each do |contributor, pull_requests|
      merged_pull_requests_by_contributor[contributor] = pull_requests.count
    end

    merged_pull_requests_by_contributor
  end

  def external_merged_pull_requests_percentage(repo, options = {})
    if TEAM_MEMBER_USERNAMES.empty?
      puts "Note: skipping external pull requests % calculation as TEAM_MEMBER_USERNAMES is empty"
      return 0      
    end

    pull_requests = pull_requests_for_repo(repo, { state: 'closed' }.merge(options))

    merged_pull_requests = pull_requests.select { |pull_request| pull_request.merged_at }

    internal_pull_requests = merged_pull_requests.select { |pull_request| TEAM_MEMBER_USERNAMES.map(&:downcase).include?(pull_request.user.login) }
    external_pull_requests = merged_pull_requests - internal_pull_requests

    external_pull_requests.count.to_f / pull_requests.count
  end

  def pull_requests_for_repo(repo, options = {})
    pull_requests = client.pull_requests(repo, options)
    pull_requests.concat(client.get(client.last_response.rels[:next].href)) while client.last_response.rels[:next]
    pull_requests
  end

  def issues_for_repo(repo, options = {})
    issues = client.issues(repo, options)
    issues.concat(client.get(client.last_response.rels[:next].href)) while client.last_response.rels[:next]
    issues
  end
end

if __FILE__ == $0
  if ARGV[0].nil?
    puts "Please provide a GitHub repo name: 'ruby ./main.rb your/repo_name"
    exit
  end

  puts "Analyzing #{ARGV[0]}..."

  GithubHealth.new.then do |service|
    puts "Average time to first response for issues: #{service.time_to_first_response_for_issues(ARGV[0]).round(1)} days"
    puts "Average time to close for issues: #{service.time_to_close_for_issues(ARGV[0]).round(1)} days"
    puts "Percentage of issues closed after first comment: #{(service.issues_closed_after_first_comment(ARGV[0]) * 100).round(2)}%"
    puts "Average days since last commit on open pull requests: #{service.days_since_last_commit_of_pull_requests(ARGV[0]).round(1)} days"
    puts "Percentage of pull requests open more than 30 days: #{(service.pull_requests_open_more_than_30_days(ARGV[0]) * 100).round(2)}%"
    puts "Percentage of reviewed pull requests without follow up: #{(service.reviewed_pull_requests_without_follow_on(ARGV[0]) * 100).round(2)}%"
    puts "External merged pull requests percentage: #{(service.external_merged_pull_requests_percentage(ARGV[0]) * 100).round(2)}%"
    puts "Merged pull requests by contributor: #{service.merged_pull_requests_by_contributor(ARGV[0])}"
  end
end