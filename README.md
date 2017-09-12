# NOTE

**This repository is not being maintained anymore. Sorry for the inconvenience this may have caused.**

## Welcome to Teecket

Teecket is a gem that will search from AirAsia, Firefly, Malaysia Airlines and
Malindo Air from the comfort of your command line.

[![Code
Climate](https://codeclimate.com/github/amree/teecket/badges/gpa.svg)](https://codeclimate.com/github/amree/teecket)
[![Travis CI](https://travis-ci.org/amree/teecket.svg)](https://travis-ci.org/amree/teecket)

## Installation

At the command prompt, install it using `gem`:

    gem install teecket

## Usage

This is an example for a working command:

    teecket KUL KBR 30-07-2015

If you're unsure, typing just the `teecket` will yield:

    teecket KBR KUL 30-07-2015

This is an example of an output:

    +-------------------+-----------------+---------+--------+-------------+----------+----------+-----------+
    | Flight            | Flight #        | Transit | Origin | Destination | Depart   | Arrive   | Fare (RM) |
    +-------------------+-----------------+---------+--------+-------------+----------+----------+-----------+
    | Malaysia Airlines | FY5311 + FY5333 | YES     | KBR    | JHB         | 08:00 AM | 11:40 AM |    296.20 |
    | Malaysia Airlines | MH5427          | NO      | KBR    | JHB         | 08:50 AM | 10:30 AM |    239.55 |
    | Malaysia Airlines | FY5305 + FY5491 | YES     | KBR    | JHB         | 01:25 PM | 05:10 PM |    296.20 |
    | Malaysia Airlines | FY5323 + FY5339 | YES     | KBR    | JHB         | 02:50 PM | 06:20 PM |    296.20 |
    | Malaysia Airlines | FY5325 + FY5341 | YES     | KBR    | JHB         | 03:35 PM | 07:50 PM |    296.20 |
    | Malaysia Airlines | FY5505 + FY5343 | YES     | KBR    | JHB         | 06:25 PM | 09:30 PM |    296.20 |
    | Malaysia Airlines | FY5321 + FY5331 | YES     | KBR    | JHB         | 10:20 PM | 08:15 AM |    296.20 |
    | Malindo Air       | OD1241 + OD1201 | YES     | KBR    | JHB         | 01:25 AM | 09:50 AM |    141.00 |
    | Malindo Air       | OD1255 + OD1201 | YES     | KBR    | JHB         | 03:10 AM | 09:50 AM |    141.00 |
    | Malindo Air       | OD1243 + OD1201 | YES     | KBR    | JHB         | 04:25 AM | 09:50 AM |    141.00 |
    | Malindo Air       | OD1235 + OD1201 | YES     | KBR    | JHB         | 06:05 AM | 09:50 AM |    141.00 |
    | Malindo Air       | OD1245 + OD1217 | YES     | KBR    | JHB         | 09:15 AM | 01:00 PM |    141.00 |
    | Malindo Air       | OD1245 + OD1213 | YES     | KBR    | JHB         | 09:15 AM | 02:00 PM |    141.00 |
    | Firefly           | FY2231          | NO      | KBR    | JHB         | 08:50 AM | 10:30 AM |    200.29 |
    +-------------------+-----------------+---------+--------+-------------+----------+----------+-----------+

## Parameters

| Params    | Type   | Required? | Remarks                    |
|-----------|--------|-----------|----------------------------|
| from      | String | yes       | Airport code, e.g: KUL     |
| to        | String | yes       | Airport code, e.g: KUL     |
| date      | String | yes       | dd-mm-yyyy, yyyy-mm-dd, dd/mm/yyyy, etc |
| verbose   | String | no        | verbosity                  |

## Development


Make sure you've installed all the dependencies first by running:

    bundle

You can use this command to test this source code:

    ruby -Ilib ./bin/teecket KBR SZB 12-12-2016

## Contributing

I'm using Rubocop and Hound to ensure some convention/quality for this project.
You can run it with:

    rubocop -c .ruby-style.yml

It'll help this gem stay alive, so, please do :)

# Live Demo

[Teecket](http://teecket.herokuapp.com)

## License

Teecket is released under the [MIT
License](http://www.opensource.org/licenses/MIT).
