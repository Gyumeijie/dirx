'use strict';
var inquirer = require('inquirer');
var args = process.argv;
var choices = args.slice(2);

choices.map(function(element, index) {
   return element.split(/#|@/)[0];
})

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