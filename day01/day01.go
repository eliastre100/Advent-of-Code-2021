package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Scan()
	depth, _ := strconv.Atoi(scanner.Text())
	fmt.Printf("Start at %d\n", depth)

	increases := 0
	for scanner.Scan() {
		currentDepth, _ := strconv.Atoi(scanner.Text())

		if depth < currentDepth {
			fmt.Printf("Increased from %d to %d\n", depth, currentDepth)
			increases += 1
		}
		depth = currentDepth
	}

	fmt.Printf("Increased %d times and eneded up at %d\n", increases, depth)

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
