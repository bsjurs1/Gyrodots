//
//  Constants.swift
//  Gyroball project
//
//  Created by Bjarte Sjursen on 07.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

//List of global constants

import UIKit

//---------------- Constants determined at compile time

//Collision detection constants
let playerCollisionCategory : UInt32 = 1
let bulletCollisionCategory : UInt32 = 2

//Other
var isIphone4ScreenSize = false

//High-pass filtering related constants
let kUpdateFrequency = 60.0
let cutOffFrequency = 5.0
let dt = 1.0/kUpdateFrequency
let RC = 1.0/cutOffFrequency
let filterConstant = RC/(dt+RC)

//Color Scheme related constants
let gameSceneBackgroundColor = UIColor(red: 0.0000, green: 0.5686, blue: 0.5725, alpha: 1.0)
//UIColor(red: 1.0000, green: 0.6039, blue: 0.2157, alpha: 1.0)
//UIColor(red: 1.0000, green: 0.5922, blue: 0.2118, alpha: 1.0)
// Blue color UIColor(red: 0.2863, green: 0.7412, blue: 0.8275, alpha: 1.0)
let playerSpriteFillColor = UIColor(red: 0.0000, green: 0.9804, blue: 0.6196, alpha: 1.0)
//UIColor(red: 0.8706, green: 0.1529, blue: 0.0980, alpha: 1.0)
//UIColor(red: 0.9961, green: 0.0275, blue: 0.9333, alpha: 1.0)
//UIColor(red: 0.1216, green: 0.8392, blue: 0.3765, alpha: 1.0)
//UIColor(red: 0.1922, green: 0.6549, blue: 0.3569, alpha: 1.0)
//UIColor(red: 0.9961, green: 0.3529, blue: 0.2118, alpha: 1.0)
//UIColor(red: 0.8667, green: 0.1608, blue: 0.0980, alpha: 1.0)
//Yellow color UIColor(red: 0.9686, green: 0.8431, blue: 0.1529, alpha: 1.0)
let playerSpriteStrokeColor = UIColor.clear
let playerSpriteFontColor = UIColor.white
let gameplayTimerFillColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.13)
//UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.13)
let gameplayTimerStrokeColor = UIColor.clear
let gameplayTimerFontColor = UIColor.white
let bulletFillColor = UIColor(red: 0.8471, green: 0.5176, blue: 0.9686, alpha: 1.0)
//UIColor(red: 0.0824, green: 0.8431, blue: 0.8510, alpha: 1.0)
//UIColor(red: 0.0000, green: 0.7255, blue: 0.8196, alpha: 1.0)
//UIColor(red: 0.0000, green: 0.5686, blue: 0.5725, alpha: 1.0)
//UIColor(red: 0.4118, green: 0.0471, blue: 0.9098, alpha: 1.0)
let bulletStrokeColor = UIColor.clear
let bulletTargetFillColor = UIColor(red: 0.8471, green: 0.5176, blue: 0.9686, alpha: 0.85)
//UIColor(red: 0.0824, green: 0.8431, blue: 0.8510, alpha: 0.3)
//UIColor(red: 0.4118, green: 0.0471, blue: 0.9098, alpha: 0.3)
//UIColor(red: 0.9451, green: 0.0000, blue: 0.1255, alpha: 0.5)
let bulletTargetStrokeColor = bulletFillColor
//UIColor(red: 0.4118, green: 0.0471, blue: 0.9098, alpha: 1.0)
//UIColor(red: 0.9451, green: 0.0000, blue: 0.1255, alpha: 1.0)
let speechBubbleColor = UIColor.white
let speechBubbleFillColor = UIColor.white
let speechBubbleStrokeColor = UIColor.white
let speechBubbleFontColor = UIColor.black
let playButtonFillColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.13)
let playButtonStrokeColor = UIColor.clear
let pauseScreenFillColor = UIColor.clear
let pauseScreenStrokeColor = UIColor.clear

let uiAnimationDuration = 0.5

let apiWebAddress = "https://ancient-bayou-30423.herokuapp.com/api/"

//Constants stored in NSUserDefaults()
let isMusicOnString = "isMusicOn" //-- bool used to see if the music shall be played
let isAppUsedString = "appIsUsed"  //-- bool used at launch to see if the app has been used before
let myScoreString = "myScore" //-- the stored top score of the player owning the phone
let hasLoginKeyString = "hasLoginKey" //-- used to determine if the player has a login key available
let usernameString = "username"//-- string used to store username of the player
let firstScoreString = "firstScore" //-- used to see if the score is the first one to be registered by the user
let numberOfTimesPlayedString = "numberOfTimesPlayed"

//---------------- Constants determined at runtime
var screenSize : CGSize!
var token = ""
