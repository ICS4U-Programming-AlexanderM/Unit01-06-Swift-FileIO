import Foundation
//  Created by Alexander Matheson
//  Created on 2023-Mar-08
//  Version 1.0
//  Copyright (c) 2023 Alexander Matheson. All rights reserved.
//
//  This program reads input from a file and prints output to a different file.

// Enum for error checking.
enum InputError: Error {
  case InvalidInput
}

// Declare variables.
var lineCounter = 0
var elementCounter = 0
var sum = 0
var errorOccurred = false

// Function to convert string from array to int.
func convert(element: Substring) throws -> Int {
  guard let number = Int(element.trimmingCharacters(in: CharacterSet.newlines)) else {
    throw InputError.InvalidInput
  }
  return number
}

// Define the input and output file paths.
let inputFile = "input.txt"
let outputFile = "output.txt"

// I could not get the method to read from and write to files from the class website to work.
// So I am using this method instead.
// It uses a "File Handle" instead of a URL to locate files.
// Open the input file for reading.
guard let input = FileHandle(forReadingAtPath: inputFile) else {
  print("Error: Cannot open input file.")
  exit(1)
}

// Open the output file for writing.
guard let output = FileHandle(forWritingAtPath: outputFile) else {
  print("Error: Cannot open output file.")
  exit(1)
}

// Read the contents of the input file.
let inputData = input.readDataToEndOfFile()

// Convert the data to a string.
guard let inputString = String(data: inputData, encoding: .utf8) else {
  print("Error: Cannot convert input data to string.")
  exit(1)
}

// Split the string into lines.
// Uses this method of splitting in order to be able to detect empty lines.
let inputLines = inputString.components(separatedBy: .newlines)

// Iterate over the lines and calculate the sum of integers on the lines.
for lineCounter in inputLines {
  // Check if line is empty.
  if lineCounter.isEmpty {
    let emptyMessage = "Error: line is empty.\n"
    output.write(emptyMessage.data(using: .utf8)!)
  } else {
    // Split the line by spaces.
    let strArray = lineCounter.split(separator: " ")
    // Second loop to run through each element in line.
    for position in strArray {
      do {
        // Increase the sum.
        sum = try sum + convert(element: position)
      } catch {
        // Display error message in the output file.
        let errorMessage = "Error: \(position) is invalid.\n"
        output.write(errorMessage.data(using: .utf8)!)
        // Indicate that an error has occurred.
        errorOccurred = true
        // Exit loop.
        break
      }
    }
    // Check if error has occurred.
    if errorOccurred == false {
      // Write the sum to the output file.
      let sumString = "\(sum)\n"
      output.write(sumString.data(using: .utf8)!)
    }
  }

  // Set errorOccurred to false.
  errorOccurred = false
  // Set sum to 0.
  sum = 0
}
// Close the files.
input.closeFile()
output.closeFile()
