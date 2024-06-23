#Include <Converters\Number>
#Include <Tools\CleanInputBox>
#Include <Extensions\String>
#Include <App\Browser>
#Include <Tools\Info>

class InternetSearch extends CleanInputBox {

	__New(searchEngine) {
		super.__New()
		this.SelectedSearchEngine := this.AvailableSearchEngines[searchEngine]
	}

	static FeedQuery(input) {
		restOfLink := this.SanitizeQuery(input)
		if (this.SelectedSearchEngine == this.AvailableSearchEngines['AHK-V2-Docs']) {
			Browser.RunLink("https://duckduckgo.com/?q=site:autohotkey.com/boards%20" restOfLink)
			Browser.RunLink(this.SelectedSearchEngine restOfLink)
		}
		Else {
			Browser.RunLink(this.SelectedSearchEngine restOfLink)
		}
	}

	static DynamicallyReselectEngine(input) {
		for key, value in this.SearchEngineNicknames {
			if input.RegExMatch("^" key "* ") {
				this.SelectedSearchEngine := value
				input := input[3, -1]
				break
			}
			else {
				this.SelectedSearchEngine := this.AvailableSearchEngines['Google'] ; sets default search to Google if no RegexMatch occurs.
			}
		}
		return input
	}

	static TriggerSearch(input) {
		query := this.DynamicallyReselectEngine(input)
		this.FeedQuery(query)
	}

	static AvailableSearchEngines := Map(
		"Google",  "https://www.google.com/search?q=",
		"Youtube", "https://www.youtube.com/results?search_query=",
		"DuckDuckGo",  "https://duckduckgo.com/?q=",
		"Bing-FMGlobal",  "https://www.bing.com/work/search?q=",
		"Wikipedia",  "https://en.wikipedia.org/w/index.php?title=Special:Search&search=",
		"AHK-V2-Docs",   "https://duckduckgo.com/?q=site:autohotkey.com/docs/v2/%20",
		; "Rust Docs", "https://doc.rust-lang.org/stable/std/path/struct.PathBuf.html?search=",
	)

	static SearchEngineNicknames := Map(
		"g",  this.AvailableSearchEngines["Google"],
		"y",  this.AvailableSearchEngines["Youtube"],
		"d", this.AvailableSearchEngines["DuckDuckGo"],
		"f", this.AvailableSearchEngines["Bing-FMGlobal"],
		"w",  this.AvailableSearchEngines["Wikipedia"],
		"a",  this.AvailableSearchEngines["AHK-V2-Docs"],
		; "r",  this.AvailableSearchEngines["Rust Docs"]
	)

	;Rename suggestion by @Micha-ohne-el, used to be ConvertToLink()
	static SanitizeQuery(query) {
		SpecialCharacters := '%$&+,/:;=?@ "<>#{}|\^~[]``'.Split()
		for key, value in SpecialCharacters {
			query := query.Replace(value, "%" NumberConverter.DecToHex(Ord(value), false))
		}
		return query
	}
}
