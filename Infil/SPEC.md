# Infil

## Overview

Infil is a mobile app for users to be able to plan to play Marathon with their friends. Marathon
is a new game released by the studio Bungie. In the game players are called "runners" that attempt runs
to go in and gather loot and supplies and successfully extract. The location where players are able
to extract are called "Exfils." The name of this app is meant to align with that since it is part
of the run planning process, Infil seemed like the counterpart to exfil.

The main focus of the app is to create plans for runs with friends. On first run, there will probably be
no plans so the user shoudl be able to create a plan for a run on a specific map at a specific time.
Once plans have been created they will be uploaded to a backend server. When friends of that user
open the app they should see a stack of cards containing the plans their friends have created. When
the card stack is populated with plans from friends, the user should be able to swipe the card to one edge of the screen for each shell or an 'X' indicating they do not want to join. Shells in this game are
different characters types that players can use. The shell selection should indicate to other users
in their planned runs what shell each player will be using.

## Screens

- [ ] Main Screen
- [ ] Create a Run Plan View
- [ ] Planned Runs View
- [ ] Profile

### Main Screen

The main screen should have two states. The first is the empty state. In this empty state where no runs
have been planned by a user's friends or clanmates, the view should contain two buttons. One that says
"Plan Run" and the other "View Planned Runs." Tapping the plan run button should take the user to a modal
view that will have a form the user can fill out to make a new plan with their friends. Tapping the view planned runs button should take the user to a list of plans that have already been agreed upon.

### Create a Run Plan View

This screen should typically be shown as a modal. The contents of the view should be a form the user
can complete to indicate information about the Marathon run they wish to plan. The following fields
should be included:

- [ ] Map name dropdown, which should poplulate an image of the selected map after selection
- [ ] Current user's selected shell
- [ ] Date and time of the planned run
- [ ] A list of resources or loot the user is seeking in the run
- [ ] A list of contracts the user is hoping to complete in this run with collapsible requirement details
- [ ] Save run plan button

### Planned Runs View

This view should be a list containing all the planned runs a user has agreen to join. Swiping to accept a
plan on the main view should add a new entry to this list. The list should include the map name and icons
indicating the chosen shells for each player. Tappign on a row in the list should bring up a plan details
view listing in readonly mode, all the details entered when creating the plan (resources, contracts, etc.). 

### Profile

A profile screen is available by tapping the user's icon in the top right of the main screen. This should include a larger version of the user's profile icon and username.

## Technical Requirements

The app should be built using SwiftUI and contain thorough test coverage where possible. Since there is
a backend server component that will be created separately in Go, the interface to the server should
be gRPC. For local/offline peristence, Swift Data can be used. 

## Theme

As for the visual themeing of the app. Colors and styles should be loosely based on (enough to fit) the
asthetic of Marathon and the color palette used within game. It doesn't need to feel like a first party
app but it should feel like it fits stylistically. 

## Unanswered Questions
