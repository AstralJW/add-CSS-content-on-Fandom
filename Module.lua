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
