# Specifications

Write a simple fizz-buzz application.

The original fizz-buzz consists in writing all numbers from 1 to 100, and just replacing all multiples of 3 by "fizz", all multiples of 5 by "buzz", and all multiples of 15 by "fizzbuzz". The output would look like this: "1,2,fizz,4,buzz,fizz,7,8,fizz,buzz,11,fizz,13,14,fizzbuzz,16,...".

Your goal is to implement an application that :
- Have a form that accepts five parameters : three integers int1, int2 and limit, and two strings str1 and str2.
- Display a list of strings with numbers from 1 to limit, where: all multiples of int1 are replaced by str1, all multiples of int2 are replaced by str2, all multiples of int1 and int2 are replaced by str1str2.
- Display a statistics view allowing users to know what the most frequent request has been. This view should display a graphical representation of the parameters corresponding to the most completed form, as well as the number of hits for this form.

The application needs to be:
Ready for production
Easy to maintain by other developers

## Comments

Since no design is being provided, some arbitrary choices will be made regarding the UI.
No specification is given in the case where 2 requests occurence are identical. Arbitrary choices or irrelevant result may happen
No specification is provided regarding the input data limits and size. Arbitrary choices will happen. 

# Methodology

 We will use the playground driven development for some part of the code
 We will use SwiftUI previews for the UI development
 We will move some playground driven development code to unit test for maintenance on non-regression goal.
 
 Please start reading the introduction playground
