#!/usr/bin/env node

'use strict';
var inquirer = require('inquirer');
var args = process.argv;
var dirs = args.slice(2);
var defalutStrategy = 'frequency';

dirs = dirs.map(function (element) {
   var parts = element.split(/#|@/);
   return {
      dirname: parts[0],
      frequency: parts[1],
      accessTime: parts[2]
   };
});

// Descending sort by frequency
function sortByFrequencey (dirA, dirB) {
   if (dirA.frequency < dirB.frequency) return 1;
   if (dirA.frequency > dirB.frequency) return -1;
   return 0;
}

// Descending sort by accessTime
function sortByAccessTime (dirA, dirB) {
   if (dirA.accessTime < dirB.accessTime) return 1;
   if (dirA.accessTime > dirB.accessTime) return -1;
   return 0;
}

var strategies = {
   frequency: sortByFrequencey,
   accessTime: sortByAccessTime
};

var choices = dirs.sort(strategies[defalutStrategy])
   .map(function(element) {
      return element.dirname;
   });

inquirer
   .prompt([
      {
         type: 'list',
         name: 'cd',
         message: "Which directory to change into?",
         paginated: true,
         choices: choices
      }])
   .then(answers => {
      console.error(answers.cd);
   });