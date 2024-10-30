package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"syscall"

	"github.com/playwright-community/playwright-go"
	"golang.org/x/term"
)

var colorGray = "\033[90m"
var colorReset = "\033[0m"

func main() {
	// Start Playwright
	var pw *playwright.Playwright
	var err error

	pw, err = playwright.Run()
	if err != nil {
		pw = installPlaywright()
	}

	username, password := getUserInput()

	fmt.Printf("\n%sa browser should open and direct you to the DUO confirmation page...%s\n", colorGray, colorReset)

	// Try Firefox first
	var browser playwright.Browser
	browser, err = pw.Firefox.Launch(playwright.BrowserTypeLaunchOptions{
		Headless: playwright.Bool(false), // Show the browser
	})
	// If that doesn't work then try Chrome
	if err != nil {
		browser, err = pw.Chromium.Launch(playwright.BrowserTypeLaunchOptions{
			Headless: playwright.Bool(false), // Show the browser
		})
		if err != nil {
			log.Fatalf("could not launch browser: %v", err)
		}
	}

	page, err := browser.NewPage()
	if err != nil {
		log.Fatalf("could not create page: %v", err)
	}

	if _, err = page.Goto("https://vpn.utexas.edu/iso-staff", playwright.PageGotoOptions{
		WaitUntil: playwright.WaitUntilStateDomcontentloaded,
	}); err != nil {
		log.Fatalf("could not goto: %v", err)
	}

	// Fill out login info
	if err = page.Locator("#username").Fill(username); err != nil {
		log.Fatalf("could not fill username: %v", err)
	}

	if err = page.Locator("#password").Fill(password); err != nil {
		log.Fatalf("could not fill password: %v", err)
	}

	if err = page.GetByRole("button").Click(); err != nil {
		log.Fatalf("could not click login button: %v", err)
	}

	fmt.Printf("\n%sfind the browser and do the DUO...%s\n", colorGray, colorReset)

	// Wait for navigation (redirection) to complete
	if err = page.WaitForURL("https://vpn.utexas.edu/CACHE/stc/2/index.html"); err != nil {
		log.Fatalf("could not wait for navigation: %v", err)
	}

	// Find the cookie we want
	cookies, err := page.Context().Cookies()
	if err != nil {
		log.Fatalf("could not get cookies: %v", err)
	}

	var webvpnCookie string
	for _, cookie := range cookies {
		if cookie.Name == "webvpn" {
			webvpnCookie = cookie.Value
			// fmt.Printf("Cookie: %s\n", webvpnCookie)
		}
	}

	// Cleanup
	if err = browser.Close(); err != nil {
		log.Fatalf("could not close browser: %v", err)
	}

	if err = pw.Stop(); err != nil {
		log.Fatalf("could not stop Playwright: %v", err)
	}

	fmt.Printf("\n%sthe next password prompt is asking for your local sudo passwd which is needed to run openconnect%s\n\n", colorGray, colorReset)

	launchOpenconnect(webvpnCookie)

}

func installPlaywright() *playwright.Playwright {
	println("installing playwright and it's depedencies...")
	runOption := &playwright.RunOptions{}
	err := playwright.Install(runOption)
	if err != nil {
		log.Fatalf("could not install playwright dependencies: %v", err)
	}
	pw, err := playwright.Run()
	if err != nil {
		log.Fatalf("could not start playwright %v", err)
	}
	return pw
}

func getUserInput() (string, string) {
	// Prompt the user for username
	reader := bufio.NewReader(os.Stdin)

	fmt.Print("Enter EID: ")
	username, err := reader.ReadString('\n')
	if err != nil {
		log.Fatalf("could not read username: %v", err)
	}
	username = strings.TrimSpace(username) // Trim any newline or space characters

	// Prompt for the password securely (no echo)
	fmt.Print("Enter EID password: ")
	bytePassword, err := term.ReadPassword(int(syscall.Stdin))
	if err != nil {
		log.Fatalf("could not read password: %v", err)
	}
	password := strings.TrimSpace(string(bytePassword)) // Convert to string and trim spaces
	fmt.Println()                                       // Print a newline after password input

	return username, password
}

func launchOpenconnect(cookie string) {
	cmd := exec.Command("sudo", "openconnect", "vpn.utexas.edu/iso-staff", "-v", fmt.Sprintf("--cookie=%s", cookie))

	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatalf("Failed to get stdout: %s", err)
	}

	// Get the stderr pipe to read error output as well
	stderr, err := cmd.StderrPipe()
	if err != nil {
		log.Fatalf("Failed to get stderr: %s", err)
	}

	// Start the command
	if err := cmd.Start(); err != nil {
		log.Fatalf("Failed to start command: %s", err)
	}

	// Create a goroutine to stream stdout
	go func() {
		scanner := bufio.NewScanner(stdout)
		for scanner.Scan() {
			fmt.Println(scanner.Text())
		}
	}()

	// Create a goroutine to stream stderr
	go func() {
		scanner := bufio.NewScanner(stderr)
		for scanner.Scan() {
			fmt.Println(scanner.Text())
		}
	}()

	// Wait for the command to finish
	if err := cmd.Wait(); err != nil {
		log.Fatalf("Command finished with error: %s", err)
	}
}
