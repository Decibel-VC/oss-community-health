As an open source founder and contributor turned open source investor, I’ve been on both sides of the table when it comes to looking at open source businesses. Over the last few years many VCs have started to invest in this space, and started to build their own "patterns" to figure out what projects are successful, such as star growth. This, in turn, has led founders themselves to highlight and track the same absolute numbers that VCs do (star growth, number of contributors, etc) which work for tracking “growth” of an open source community, but don’t always account for its “health”. 

Building an open source project is much more nuanced than counting stars and forks. In this post I will offer some suggestions that open source maintainers and founders can use to track the health of their communities and help them grow. This blog post also comes with a Github repo that contains code to actually measure these metrics! You can find that here: [https://github.com/Decibel-VC/oss-community-health](https://github.com/Decibel-VC/oss-community-health) 

Before we dive in, you should have a good idea of **_why_** your project is open source, and whether or not this even applies to you. I usually see two ways maintainers go at open source:

* **Open source as a _distribution_ model:** the project is usually maintained by a company that is building a commercial product on top of it. Most of the development is done by employees of the company, and it’s usually not super easy for a new contributor to get started, as a lot of the knowledge is in the heads of the employees and might not be well documented. If you look at MongoDB’s top contributors list for example, you’ll notice they are all Mongo employees; their README doesn’t include a "How To Contribute" section, and none of the recently merged Pull Requests assume that the community should be involved in any way (like [this one](https://github.com/mongodb/mongo/pull/1493), which has most of the context stored in an employee-only issue tracker).

* **Open source as a _development_ model:** these are most commonly "public goods" projects or commercial ones that have a lot of integrations. [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) is one that I’ve contributed to in the past; you’ll see that “How do I contribute?” is pretty high up in their README. It’s easy for anyone to go in there and submit new definitions for a project that is missing. Our portfolio company Cube is a good commercial example; their team makes it easy for anyone to develop a new datastore integration and get help from the Cube team; [the QuestDB integration](https://github.com/cube-js/cube.js/pull/4096) is a good example of two commercial open source companies contributing in the open.   

Both of these approaches have proven to be successful, but I’ll just focus on the second one as it’s the one that needs the most work to flourish. 

The journey of an open source contributor is made of three steps: 

* Open a Github issue with a bug report / feature idea

* Make the changes to the codebase 

* Ask for a PR review + merge

Let’s break down what’s important at each step.

**#1: Open a Github issue with a bug report / feature idea**

For your peace of mind as a maintainer, the most impactful way to save time is making sure that everything is easily searchable by your new contributors. If you only use Github, that’s not a problem. If you also have a Discord, maybe run a community forum, etc you should make sure that all information and decisions made on those platforms make it back to Github for future tracking. This will make it easy for you to reference previous decisions, as well as for new contributors to find them themselves. 

Once a contributor goes to your Issues tab, the first two things they’ll see are 1) how many of them are left with no replies 2) how many of them are closed in a timely manner. This will be very impactful in their decision to contribute (or even to just use your project at all).

Some very important metrics to track at this stage are the following:

* **% of issues created by your team vs % of issues created by external users:** As your project grows, your team becomes heavily outnumbered, and that’s where a lot of the issues start to arise, so you’ll want to track this. 

* **Time to first response:** how much time passes between a Github issue being opened and a team member responding to it? 

* **Time to close:** how much time passes between opening and closing of an issue?

* **% of issues closed after the first comment:** whenever someone opens an issue and a maintainer responds and closes it right away, it usually means that 1) the answer already existed, it just wasn’t documented 2) the issue is of bad quality. If this number is really high, that’s a bad sign. 

Each project will have very different values for each metric. I don’t think there’s a "magic" number for any of them, but what’s important is to set a goal for your team and then track the trend over time. You could use the code linked above to calculate these metrics for projects similar to yours, and use that as a starting point.

It’s also important to have a good set of labels for issues here like "wontfix", “duplicate”, etc which will help you slice and dice the metrics above.

**#2: Make the changes to the codebase**

This step of the process is hard to measure quantitatively. Most of your team’s focus here should be on the developer experience:

* If a new contributor suggests a change, do they have a way to test it with an automated suite? How easy is it for them to write their own tests? Requiring every contribution to have tests will save your team a lot of time before reviews.

* You should always make sure your build instructions are working; most contributions I gave up on were due the project not building locally, or having no instructions on how to run it to test my changes. 

After they get started and open a WIP pull request, you should have some automations set up to help with reviews. You can setup [Danger](https://danger.systems/) to make sure that all pull requests include tests, or use tools like [DeepSource](https://deepsource.io/) to automatically apply your style rules, as well as catching things like debuggers left in the code before any reviewer has to get involved. 

It’s important to keep track of the "health" of a pull request. There’s a high flight risk with first-time contributors; they are eager to get started, but getting a pull request to the finish line isn’t usually as easy as they thought. This leads to a lot of orphan pull requests, and wasted time for maintainers. For your open pull requests, you should be tracking these metrics:

* **Days since last commit:** if the contributor hasn’t pushed any new changes in a day that’s fine, but after 1 week passes it’s likely this has fallen off their priority list. You’ll want to check in on them to see if they still plan on working on it, or if you should either close it or let someone else take a stab at it.

* **Open PRs that are 30+ days old:** some PRs don’t die off completely, but also struggle to get to a "ready for review" status. You want to track how many of those you have, and decide whether you want to have your team focus on getting them to the finish line, or pull the plug on them if they aren’t trending in the right direction.

**#3: Ask for a PR review + merge**

This is the most "expensive" part of the process, as it requires the contributor and the maintainers to go back and forth on code changes. One of the main “flaws” of open source is the lack of double opt-in. Everyone can open a pull request on every repo, and this sometimes leads to a lot of noise (as you see during Hacktoberfest). As a maintainer you sometimes feel forced to respond, but that shouldn’t be the case. If people are opening low-effort pull requests or haven’t followed your guidelines / instructions, you should focus your time on helping other contributors. It’s really important to have clear expectations of what a “Ready for review” pull request looks like, so make sure that’s clear in your Contributions Guide.

The metrics I’d want to track for this stage are the following:

* **% of reviewed PRs that don’t have follow on commits:** how many pull requests did your team review that never got the suggestions implemented? This is a big time sink, so you want this number to be as low as possible.

* **Number of PRs merged by each contributor:** it’s always good to see which contributors get these changes to the finish line. It will help your team prioritize helping them in the future, as you have more confidence they will go through with it.

* **% of merged PRs from external contributors:** how much is the community contributing to the product vs your team? Again, there’s no "right" number here, just the one you are willing to support. Sometimes this is 0% because you don’t have the time to support external contributions, which is also okay.

**Contribute to this post!**

Open source software is an extremely heterogeneous community, with a lot of very opinionated folks :) To make sure every opinion is heard, we open sourced this article [here](https://github.com/Decibel-VC/oss-community-health); everyone can fork it and add suggestions / changes. We also provide some code that allows you to actually track these metrics! Hopefully it’s helpful as you get started in your open source community journey. You can reach me on Twitter or Github @fanahova with any feedback / questions as well.

