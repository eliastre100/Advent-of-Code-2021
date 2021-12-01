package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func getDepthWindow(firstDepth int, secondDepth int, scanner *bufio.Scanner) (bool, int, int, int, int) {
	if scanner.Scan() == false {
		return false, firstDepth, secondDepth, 0, firstDepth + secondDepth
	}
	thirdDepth, _ := strconv.Atoi(scanner.Text())
	return true, firstDepth, secondDepth, thirdDepth, firstDepth + secondDepth + thirdDepth
}

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Scan()
	first, _ := strconv.Atoi(scanner.Text())
	scanner.Scan()
	second, _ := strconv.Atoi(scanner.Text())

	_, _, first, second, total := getDepthWindow(first, second, scanner)
	third := 0
	windowTotal, scanned := 0, true

	increases := 0
	for {
		scanned, first, second, third, windowTotal = getDepthWindow(first, second, scanner)

		if !scanned {
			break
		}

		if total < windowTotal {
			fmt.Printf("Increased from %d to %d\n", total, windowTotal)
			increases += 1
		}
		total = windowTotal
		first = second
		second = third
	}

	fmt.Printf(" Increased %d times and eneded up at %d\n", increases, total)

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
