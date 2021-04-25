# Fauna

Los Altos Hacks V Submission - [Devpost](https://devpost.com/software/fauna-xlnfqg)

## Inspiration

Animals are everywhere, right? Even in the Bay Area, where we have everything from snakes to mountain lions to bobcats. And a surprising number of people die due to injuries from wild animals. Injuries are even more common, and treatment costs the US **billions** of dollars a year.

It's a problem that's often understated, because even though being killed by a wild animal in the US is rare, it's still possible.

And in some parts of the world, it's even _more_ common. In many third-world countries or rural regions, a lack of access to medication can mean any encounter might be fatal.

So we decided to tackle this head-on with an app that would crowdsource information to help save lives and protect people.

## What it does

The goal of our app is twofold:

- Allow users to see where wild animals have been spotted
- Allow users to add photos of wild animals they've spotted

Our app allows users to provide photos of wild animals they saw or encountered and add them to a geographic database that other users can see. We made a mobile app where users can log in, submit photos (and even take them through the app) and then immediately use computer vision and object recognition to identify the animal and add the encounter to our database. We also use Google maps to provide an interactive, location-based viewer for encounters and alerts when you might be getting close.

## How we built it

Our tech stack relied heavily on Google's Cloud Platform. 

Our API runs on **Google App Engine**
Images are stored in **Google Cloud Storage**
Animal Detection is done through **Google Vision**
We use **Google Maps** for location data.
Our front-end is built with **Flutter**

We also used **CockroackDB** for our database. We utilized their spatial functions in order to create `GEOGRAPHY` entries where we could add locations. Our **Flask** API uses SQLAlchemy to interact with the database and update values.

We use Flutter for frontend in order to build for both iOS and Android. For a project like this one, more users are essential, so we need as many platforms as possible as well. Flutter communicates to our API, which communicates to our database to read and write encounters.

## Challenges we ran into

Oh boy, there were a LOT of challenges. Most of them were in the front-end, where we ran into issues with not deciding on a framework fast enough. Our front end developers were unavailable at the beginning, so back-end had to work without really knowing how front-end would work. We also ran into issues with dependency conflicts with Flutter, and setup was painful as well.

We also ran into issues when dealing with HEIF files. Though we did find a way to convert HEIF to PNG, and to do it fast, Google Cloud Platform makes it very difficult to use the `libheif` library. 

Most constrictive of all was probably time. Not having enough time to finish and polish our front-end is really disappointing. Scrambling to get our project done is not a good feeling, and the entire team is tired and drained yet also excited and proud at the end. It's been a tough journey, with quite a few setbacks. but we're finally near the end of it.

## Accomplishments and what we've learned

This has been an amazing project to work on. We successfully wrote an complete, complex app with a full REST API that uses Google Cloud Vision components. Every bit of this project has been an accomplishment, from the tricky and time-crunched front-end to the complicated and involved back-end. We've gotten a lot better at working with Google's Cloud Platform, learned a lot about databases with CockroachDB, and we've built something brand new that is fresh and interesting to all of us. 

Things we've learned or gotten better at:
- Google Cloud Platform
- SQL
- Spatial Databases
- Flutter
- Flask

## What's next for Fauna

So, where to? Wherever we go from here, our app will help us avoid any dangerous animals :D.

Our next steps are probably to work on polish. The back-end is fast, reliable, and scalable, thanks to Google Cloud and CockroachDB, but the front-end could use some touch ups to make it just that much smoother. I have high hopes that with some more time and effort, and some focused clean up of code and UI, we'd be able to make this an app that wouldn't just be useful and valuable, but life-saving as well.

## Conclusions

Thanks for checking out Fauna! We've put a lot of time and effort into this, so we're really excited to get some feedback. Check out the Android and iOS installer files at the links below, or view our code on [Github.](https://github.com/anirudhb/fauna) Thanks!
