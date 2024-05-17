# Tom Scaled Agile

# Getting Started

Connect to your developer org or scratch rog and run:

```shell
npm install
npm run bootstrap
```

This will deploy everything and run a couple scripts to initialize permission set assignment, page layout assignment, etc.

# Additions

- Added unique constraint to registration code (since codes should be unique among meetups)
- Added external id constraint to registration code for indexing on queries

# Notes and Other Thoughts

- Would consider value of master/detail, what are we getting? Defer to lookup unless there is an explicit reason to use master/detail -- also may introduce greater risk of record locking at scale, visibility (should registrants see other registrations?)
- Should we add a required constaint to registration code on meetup? Not in the requirements but would make sense unless there is the notion of "back office" support for creationg meetups and registering users
- Sharing restrictions, went public read since that makes the most sense (organizers and registrants) in the absense of reqs
