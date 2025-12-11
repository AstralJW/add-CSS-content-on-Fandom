# add-CSS-content-on-Fandom
<h2>Fandom</h2>
<a href="www.fandom.com">Fandom</a> is a media conglomerate backed by a private equity firm TPG Capital. 

The website offers a platform for hosting wiki pages with social media features on various topics such as video games, movies, books, and TV series.The company also owns several entertainment outlets such as GameSpot and TV Guide, multimedia databases such as GameFAQs, Metacritic and ComicVine, as well as online retailers such as Fanatical[^1].

However, during the editing process, many editors aim to achieve better page rendering and an enhanced browsing experience, which requires the use of CSS.

Unfortunately, Fandom imposes strict restrictions on CSS, and using the &lt;style&gt;&lt;/style&gt; tags may result in the failure to display the intended effects. This article will teach users how to implement CSS effects on Fandom.

It is assumed that you have administrator privileges on the website; if not, you should ask for the administrator to grant you this permission.

First, locate "Contact Us" at <a href="https://support.fandom.com">https://support.fandom.com</a>, fill in and submit the form to Fandom in the following format.

If Fandom approves your request, navigate to &lt;wikiname&gt;.fandom.com/wiki/MediaWiki:Common.js on your website, where you will find the page editable.

Insert the following code[^2]:

```JavaScript
mw.hook("wikipage.content").add(function () {
    $("span.import-css").each(function () {
    	mw.util.addCSS($(this).attr("data-css"));
    });
});
```
Subsequently, create the page Module:CSS

Insert the code[^2]:

```Lua
local p = {}
local allowedNS = {
	[2] = true, -- User:
	[8] = true, -- MediaWiki:
	[10] = true -- Template:
}

function p.import_css(frame)
	local content = frame:getParent().args.content or frame.args.content
	if content ~= nil then
		return tostring(mw.html.create("span")
			:addClass("import-css")
			:attr("data-css", content)
			:attr("data-css-hash", mw.hash.hashValue("sha256", content)))
	end
	
	local title = frame:getParent().args[1] or frame.args[1]
	local titleObj = mw.title.new(title or "")
	local errorMsg
	
	if title == nil then errorMsg = "Error: No data for<code>{{[[T:CSS|CSS]]}}</code>."
	elseif titleObj == nil then errorMsg = "Error: The data "" .. frame:extensionTag("nowiki", title) .. ""provided for template<code>{{[[T:CSS|CSS]]}}</code> is not a valid name."
	elseif not titleObj.exists then errorMsg = "Error: The data provided for the page "[[" .. title .. "]]" of template<code>{{[[T:CSS|CSS]]}}</code> do not exist."
	elseif not allowedNS[titleObj.namespace] then errorMsg = "Error: The name "[[" .. title .. "]]" of <code>{{[[T:CSS|CSS]]}}</code> template“[[" .. title .. "]]”does not belong to any namespace among MediaWiki, Template or User."
	elseif titleObj.contentModel ~= "css" then errorMsg = "Error: Content Model Error." end
	
	if errorMsg ~= nil then return
		tostring(mw.html.create("strong"):addClass("error"):wikitext(errorMsg)) ..
		"[[Category:Error While Importing CSS]]"
	else
		content = titleObj:getContent()
		return tostring(mw.html.create("span")
			:addClass("import-css")
			:attr("data-css", content)
			:attr("data-css-hash", mw.hash.hashValue("sha256", content)))
	end
end

return p
```

Finally, create Template:CSS with the following code[^2]:

```HTML
<includeonly>{{#invoke:CSS|import_css}}</includeonly>
```
After completing the above steps, you only need to insert {{CSS|CSS file name (must be created within the same wiki)}} or {{CSS|content=CSS content}} on the page to apply the CSS effects.

[^1]:Fandom (website), Wikipedia, 10 Dec. 2025,  <a href="https://en.wikipedia.org/wiki/Fandom_(website)">https://en.wikipedia.org/wiki/Fandom_(website)</a>.
[^2]:MediaWiki:Common.js, Backrooms Fandom, 28 Sep. 2025, <a href="https://backrooms.fandom.com/wiki/MediaWiki:Common.js">https://backrooms.fandom.com/wiki/MediaWiki:Common.js</a>.
