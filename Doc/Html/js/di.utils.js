window.onload=LoadPage;
window.onunload=Window_Unload;
window.onbeforeprint = set_to_print;
window.onafterprint = reset_form;

var scrollPos = 0;

var inheritedMembers;
var protectedMembers;
var netcfMembersOnly;
var netXnaMembersOnly;

var editableContent;

var configurationXml;

// Initialize array of section states

var sectionStates = new Array();
var sectionStatesInitialized = false;

//Hide sample source in select element
function HideSelect()
{
	var selectTags = document.getElementsByTagName("SELECT");
	var spanEles = document.getElementsByTagName("span");
	var i = 10;
	var m;
	
	if (selectTags.length != null || selectTags.length >0)
	{
		for (n=0; n<selectTags.length; n++)
		{			
			var lan = selectTags(n).getAttribute("id").substr("10");
			//hide the first select that is on
			switch (lan.toLowerCase())
			{
				case "visualbasic":
					//alert(lan);
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "VisualBasic" && spanEles[m].style.display != "none" && n <i)
							i = n;				
					}
					break;
				case "visualbasicdeclaration":
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "VisualBasicDeclaration" && spanEles[m].style.display != "none" && n < i)
							i = n;
					}
					break;
				case "visualbasicusage":
					//alert(lan);
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "VisualBasicUsage" && spanEles[m].style.display != "none" && n <i)
							i = n;				
					}
					break;
				case "csharp":
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "CSharp" && spanEles[m].style.display != "none" && n < i)
							i = n;
					}
					break;
				case "managedcplusplus":
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "ManagedCPlusPlus" && spanEles[m].style.display != "none" && n < i)
							i = n;
					}
					break;
				case "jsharp":
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "JSharp" && spanEles[m].style.display != "none" && n < i)
							i = n;
					}
					break;
				case "jscript":
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "JScript" && spanEles[m].style.display != "none" && n < i)
							i = n;
					}
					break;				
				case "xaml":
					//alert(lan);
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "XAML" && spanEles[m].style.display != "none" && n <i)
							i = n;				
					}
					break;
				case "javascript":
					//alert(lan);
					for (m=0; m<spanEles.length; m++)
					{					
						if (spanEles[m].getAttribute("codeLanguage") == "JavaScript" && spanEles[m].style.display != "none" && n <i)
							i = n;				
					}
					break;
			}							
		}
		if (i != 10)		
			selectTags(i).style.visibility = "hidden";
	}
	else{ alert("Not found!");}	
}

function UnHideSelect()
{		
	var selectTags = document.getElementsByTagName("SELECT");
	var n;
	
	//un-hide all the select sections
	if (selectTags.length != null || selectTags.length >0)
	{
		for (n=0; n<selectTags.length; n++)
			selectTags(n).style.visibility = "visible";
	}	
}

function InitSectionStates()
{
  sectionStatesInitialized = true;
  // SectionStates has the format:
  //
  //     firstSectionId:state|secondSectionId:state|thirdSectionId:state| ... |lastSectionId:state
  //
  // where state is either "e" (expanded) or "c" (collapsed)
  
  // get the SectionStates from the previous topics
  if (globals == null)
    globals = GetGlobals();
  var states = Load("SectionStates");

  var start = 0;
  var end;
  var section;
  var state;
  var allCollapsed = false;
  // copy the previous section states to the sectionStates array for the current page
	if (states != null && states != "")
	{
    allCollapsed = true;
    while (start < states.length)
    {
      end = states.indexOf(":", start);
      
      section = states.substring(start, end);
      
      start = end + 1;
      end = states.indexOf("|", start);
      if (end == -1) end = states.length;
      state = states.substring(start, end);
      sectionStates[section] = state;
	    allCollapsed = allCollapsed && (state == "c");
	    start = end + 1;
    }
	}
    
  // now set the state for any section ids in the current document that weren't in previous
	var imgElements = document.getElementsByName("toggleSwitch");
	var i;
	for (i = 0; i < imgElements.length; ++i)
    sectionStates[imgElements[i].id] = GetInitialSectionState(imgElements[i].id, allCollapsed);
}

function GetInitialSectionState(itemId, allCollapsed)
{
  // if the global state is "allCollapsed", set all section states to collapsed
  if (allCollapsed) return "c";
  
  // generic <section> node ids begin with "sectionToggle", so the same id can refer to different sections in different topics
  // we don't want to persist their state; set it to expanded 
  if (itemId.indexOf("sectionToggle", 0) == 0) return "e";
  
  // the default state for new section ids is expanded 
  if (sectionStates[itemId] == null) return "e";
  
  // otherwise, persist the passed in state
  return sectionStates[itemId];
}

var noReentry = false;

function OnLoadImage(eventObj)
{
  if (noReentry) return;
  
  if (!sectionStatesInitialized) 
    InitSectionStates(); 
 
  var elem;
  if(document.all) elem = eventObj.srcElement;
  else elem = eventObj.target;
      
  if (sectionStates[elem.id] == "e")
    ExpandSection(elem);
  else
    CollapseSection(elem);
}

function InitializeConfiguration()
{
    if (configurationXml == null)
    {
        configurationXml = new ActiveXObject("MSXML2.DOMDocument.6.0");
        configurationXml.async = false;
        configurationXml.load("Configurations.xml");
        configurationXml.setProperty("SelectionLanguage", "XPath");
        if (configurationXml.parseError.errorCode != 0) {
           var e = configurationXml.parseError;
           alert(e.reason);
        }
    }

    /*
    var xmlSource, sharedXSLT, sharedCache;
    xmlSource = new ActiveXObject("MSXML2.DOMDocument.6.0");
    xmlSource.async = false;

    sharedXSLT = new ActiveXObject("MSXML2.FreeThreadedDOMDocument.6.0");
    sharedXSLT.async = false;
    sharedXSLT.load('Transforms/Shared.xsl');

    sharedCache = new ActiveXObject("Msxml2.XSLTemplate.6.0");
    sharedCache.stylesheet = sharedXSLT;
    */
}


/*	
**********
**********   Begin
**********
*/

var docSettings = null;

function LoadPage()
{
    if (contentEditableControl.value == "true")
    {
        AddRowToTable("exceptions");
        AddRowToTable("permissions");
        AddRowToTable("authors");
        AddRowToTable("seealso");
        AddRowToDefTables();
    }

	// docSettings has settings for the current document, 
	// which include persistent and non-persistent keys for checkbox filters and expand/collapse section states
	// persistKeys is an array of the checkbox ids to persist
	if (docSettings == null) 
	{
    docSettings = new Array();
    persistKeys = new Array();
	}
	
  if (!sectionStatesInitialized) 
	  InitSectionStates(); 

	var imgElements = document.getElementsByName("toggleSwitch");
	
	for (i = 0; i < imgElements.length; i++)
	{
		if ((sectionStates[imgElements[i].id] == "e"))
			ExpandSection(imgElements[i]);
		else
			CollapseSection(imgElements[i]);
	}
	
	SetCollapseAll();

    /*
	// split screen
	var screen = new SplitScreen('header', 'mainSection');
    */

	// init devlang filter checkboxes
	SetupDevlangsFilter();
	
	// init memberlist filter checkboxes for protected, inherited, etc
	SetupMemberOptionsFilter();
	
	// init memberlist platforms filter checkboxes, e.g. .Net Framework, CompactFramework, XNA, Silverlight, etc.
	SetupMemberFrameworksFilter();
	
  var mainSection = document.getElementById("mainSection");
	
	// vs70.js did this to allow up/down arrow scrolling, I think
	try { mainSection.setActive(); } catch(e) { }

	//set the scroll position
	try{mainSection.scrollTop = scrollPos;}
	catch(e){}


  //*
    watchContentEditableElements();
  //*/
}

function Window_Unload()
{
  // for each key in persistArray, write the key/value pair to cookie file
  for (var i = 0; i < persistKeys.length; i++)
    Save(persistKeys[i], docSettings[persistKeys[i]], 365);
  
  // save the expand/collapse section states
  SaveSections();
}

function set_to_print()
{
	//breaks out of divs to print
	var i;

	if (window.text)document.all.text.style.height = "auto";
			
	for (i=0; i < document.all.length; i++)
	{
		if (document.all[i].tagName == "body")
		{
			document.all[i].scroll = "yes";
		}
		if (document.all[i].id == "header")
		{
			document.all[i].style.margin = "0px 0px 0px 0px";
			document.all[i].style.width = "100%";
		}
		if (document.all[i].id == "mainSection")
		{
			document.all[i].style.overflow = "visible";
			document.all[i].style.top = "5px";
			document.all[i].style.width = "100%";
			document.all[i].style.padding = "0px 10px 0px 30px";
		}
	}
}

function reset_form()
{
	//returns to the div nonscrolling region after print
	document.location.reload();
}

/*	
**********
**********   End
**********
*/


/*	
**********
**********   Begin Language Filtering
**********
*/

var devlangsMenu;
var devlangsDropdown;
var memberOptionsMenu;
var memberOptionsDropdown;
var memberFrameworksMenu;
var memberFrameworksDropdown;
var dropdowns = new Array();

// initialize the devlang filter dropdown menu
function SetupDevlangsFilter()
{
  var divNode = document.getElementById('devlangsMenu');
	if (divNode == null)
	  return;

	var checkboxNodes = divNode.getElementsByTagName("input");
	
	if (checkboxNodes.length == 1)
	{
    // only one checkbox, so we don't need a menu
    // get the devlang and use it to display the correct devlang spans
    // a one-checkbox setting like this is NOT persisted, nor is it set from the persisted cookie file
    var checkboxData = checkboxNodes[0].getAttribute('data');
    var dataSplits = checkboxData.split(',');
    var devlang = "";
    if (dataSplits.length > 1)
      devlang = dataSplits[1];
    styleSheetHandler(devlang);
	}
	else
	{
    // setup the dropdown menu
    devlangsMenu = new CheckboxMenu("devlangsMenu", docSettings, persistKeys, globals);
		devlangsDropdown = new Dropdown('devlangsDropdown', 'devlangsMenu');
		dropdowns.push(devlangsDropdown);

    // update the label of the dropdown menu
    SetDropdownMenuLabel(devlangsMenu, devlangsDropdown);
        
    // toggle the document's display docSettings
	  codeBlockHandler();
	  styleSheetHandler("");
	}
}


// called onclick in a devlang filter checkbox
// tasks to perform at this event are:
//   toggle the check state of the checkbox that was clicked
//   update the user's devlang preference, based on devlang checkbox states
//   update stylesheet based on user's devlang preference
//   show/hide snippets/syntax based on user's devlang preference
//   
function SetLanguage(checkbox)
{
  // toggle the check state of the checkbox that was clicked
  devlangsMenu.ToggleCheckState(checkbox.id);
    
  // update the label of the dropdown menu
  SetDropdownMenuLabel(devlangsMenu, devlangsDropdown);
	
  // update the display of the document's items that are dependent on the devlang setting
	codeBlockHandler();
	styleSheetHandler("");
}

/*	
**********
**********   End Language Filtering
**********
*/


/*	
**********
**********   Begin Members Options Filtering
**********
*/

// initialize the memberlist dropdown menu for protected, inherited, etc
function SetupMemberOptionsFilter()
{
	if (document.getElementById('memberOptionsMenu') != null) {
    memberOptionsMenu = new CheckboxMenu("memberOptionsMenu", docSettings, persistKeys, globals);
		memberOptionsDropdown = new Dropdown('memberOptionsDropdown', 'memberOptionsMenu');
		dropdowns.push(memberOptionsDropdown);

    // update the label of the dropdown menu
    SetDropdownMenuLabel(memberOptionsMenu, memberOptionsDropdown);
        
    // show/hide memberlist rows based on the current docSettings
	  memberlistHandler();
	}
}

function SetupMemberFrameworksFilter()
{
	if (document.getElementById('memberFrameworksMenu') != null) 
	{
    memberFrameworksMenu = new CheckboxMenu("memberFrameworksMenu", docSettings, persistKeys, globals);
		memberFrameworksDropdown = new Dropdown('memberFrameworksDropdown', 'memberFrameworksMenu');
		dropdowns.push(memberFrameworksDropdown);

    // update the label of the dropdown menu
    SetDropdownMenuLabel(memberFrameworksMenu, memberFrameworksDropdown);
        
    // show/hide memberlist rows based on the current docSettings
    memberlistHandler();
	}
}

function SetMemberOptions(checkbox, groupName)
{
  var checkboxGroup = new Array();
  if (groupName == "vis")
  {
      if (document.getElementById('PublicCheckbox') != null)
          checkboxGroup.push('PublicCheckbox');
      if (document.getElementById('ProtectedCheckbox') != null)
          checkboxGroup.push('ProtectedCheckbox');
  }
  else if (groupName == "decl")
  {
      if (document.getElementById('DeclaredCheckbox') != null)
          checkboxGroup.push('DeclaredCheckbox');
      if (document.getElementById('InheritedCheckbox') != null)
          checkboxGroup.push('InheritedCheckbox');
  }
  
  // toggle the check state of the checkbox that was clicked
  memberOptionsMenu.ToggleGroupCheckState(checkbox.id, checkboxGroup);
  
  // update the label of the dropdown menu
  SetDropdownMenuLabel(memberOptionsMenu, memberOptionsDropdown);

  // update the display of the document's items that are dependent on the member options settings
  memberlistHandler();
}

function SetMemberFrameworks(checkbox)
{
  // toggle the check state of the checkbox that was clicked
  memberFrameworksMenu.ToggleCheckState(checkbox.id);
  
  // update the label of the dropdown menu
  SetDropdownMenuLabel(memberFrameworksMenu, memberFrameworksDropdown);

  // update the display of the document's items that are dependent on the member platforms settings
  memberlistHandler();
}

function DisplayFilteredMembers()
{
	var iAllMembers = document.getElementsByTagName("tr");
	var i;
	
	for(i = 0; i < iAllMembers.length; ++i)
	{
		if (((iAllMembers[i].notSupportedOnXna == "true") && (netXnaMembersOnly == "on")) ||
			((iAllMembers[i].getAttribute("name") == "inheritedMember") && (inheritedMembers == "off")) ||
			((iAllMembers[i].getAttribute("notSupportedOn") == "netcf") && (netcfMembersOnly == "on")))
			iAllMembers[i].style.display = "none";
		else
			iAllMembers[i].style.display = "";
	}
	
	// protected members are in separate collapseable sections in vs2005, so expand or collapse the sections
	ExpandCollapseProtectedMemberSections();
}

function ExpandCollapseProtectedMemberSections()
{
	var imgElements = document.getElementsByName("toggleSwitch");
	var i;
	// Family
	for(i = 0; i < imgElements.length; ++i)
	{
		if(imgElements[i].id.indexOf("protected", 0) == 0)
		{
	        if ((sectionStates[imgElements[i].id] == "e" && protectedMembers == "off") || 
	            (sectionStates[imgElements[i].id] == "c" && protectedMembers == "on"))
			{
				ExpandCollapse(imgElements[i]);
			}
		}
	}
}

/*	
**********
**********   End Members Options Filtering
**********
*/


/*	
**********
**********   Begin Expand/Collapse
**********
*/

function getNextElementSibling( el ) {
    do { el = el.nextSibling } while ( el && el.nodeType !== 1 );
    return el;
}

function GetCollapseableSection(imageItem)
{
  var node = imageItem.parentNode.parentNode.parentNode;  
  return node.nextElementSibling || getNextElementSibling(node);
}

// expand or collapse a section
function ExpandCollapse(imageItem)
{
	if (sectionStates[imageItem.id] == "e")
		CollapseSection(imageItem);
	else
		ExpandSection(imageItem);
	
	SetCollapseAll();
}

// expand or collapse all sections
function ExpandCollapseAll(imageItem)
{
  var collapseAllImage = document.getElementById("collapseAllImage");
  var expandAllImage = document.getElementById("expandAllImage");
  if (imageItem == null || collapseAllImage == null || expandAllImage == null) return;
  noReentry = true; // Prevent entry to OnLoadImage
    
	var imgElements = document.getElementsByName("toggleSwitch");
	var i;
	var collapseAll = (imageItem.src == collapseAllImage.src);
	if (collapseAll)
	{
		imageItem.src = expandAllImage.src;
		imageItem.alt = expandAllImage.alt;

		for (i = 0; i < imgElements.length; ++i)
		{
			CollapseSection(imgElements[i]);
		}
	}
	else
	{
		imageItem.src = collapseAllImage.src;
		imageItem.alt = collapseAllImage.alt;

		for (i = 0; i < imgElements.length; ++i)
		{
			ExpandSection(imgElements[i]);
		}
	}
	SetAllSectionStates(collapseAll);
	SetToggleAllLabel(collapseAll);
	
	noReentry = false;
}

function ExpandCollapse_CheckKey(imageItem, eventObj)
{
	if(eventObj.keyCode == 13)
		ExpandCollapse(imageItem);
}

function ExpandCollapseAll_CheckKey(imageItem, eventObj)
{
	if(eventObj.keyCode == 13)
		ExpandCollapseAll(imageItem);
}

function SetAllSectionStates(collapsed)
{
  for (var sectionId in sectionStates) 
    sectionStates[sectionId] = (collapsed) ? "c" : "e";
}

function ExpandSection(imageItem)
{
  noReentry = true; // Prevent re-entry to OnLoadImage
  try
  {
    var collapseImage = document.getElementById("collapseImage");
	  imageItem.src = collapseImage.src;
	  imageItem.alt = collapseImage.alt;
	var e = GetCollapseableSection(imageItem);
	  $(e).show();
	if (e != null)
		$(e.parentNode).css("min-height", "60px");
    sectionStates[imageItem.id] = "e";
  }
  catch (e)
  {
  }
  noReentry = false;
}

function CollapseSection(imageItem)
{
  noReentry = true; // Prevent re-entry to OnLoadImage
  var expandImage = document.getElementById("expandImage");
	imageItem.src = expandImage.src;
	imageItem.alt = expandImage.alt;
	var e = GetCollapseableSection(imageItem);
	  $(e).hide();
	if (e != null)
	  $(e.parentNode).css("min-height", "0px");	
	  sectionStates[imageItem.id] = "c";
  noReentry = false;
}

function AllCollapsed()
{
	var imgElements = document.getElementsByName("toggleSwitch");
	var allCollapsed = true;
	var i;
		
	for (i = 0; i < imgElements.length; i++) allCollapsed = allCollapsed && (sectionStates[imgElements[i].id] == "c");
	
	return allCollapsed;
}

function SetCollapseAll()
{
	var imageElement = document.getElementById("toggleAllImage");
	if (imageElement == null) return;
	
	var allCollapsed = AllCollapsed();
	if (allCollapsed)
	{
    var expandAllImage = document.getElementById("expandAllImage");
    if (expandAllImage == null) return;
		imageElement.src = expandAllImage.src;
		imageElement.alt = expandAllImage.alt;
	}
	else
	{
    var collapseAllImage = document.getElementById("collapseAllImage");
	  if (collapseAllImage == null) return;
		imageElement.src = collapseAllImage.src;
		imageElement.alt = collapseAllImage.alt;
	}
	
	SetToggleAllLabel(allCollapsed);
}

function SetToggleAllLabel(allCollapsed)
{
	var collapseLabelElement = document.getElementById("collapseAllLabel");
	var expandLabelElement = document.getElementById("expandAllLabel");
	
	if (collapseLabelElement == null || expandLabelElement == null) return;
		
	if (allCollapsed)
	{
		collapseLabelElement.style.display = "none";
		expandLabelElement.style.display = "inline";
	}
	else
	{
		collapseLabelElement.style.display = "inline";
		expandLabelElement.style.display = "none";
	}
}

function SaveSections()
{
  try
  {
    var states = "";
  
    for (var sectionId in sectionStates) 
      states += sectionId + ":" + sectionStates[sectionId] + "|";
    
    Save("SectionStates", states.substring(0, states.length - 1), 365);
  }
  catch (e)
  {
  }   
}

function OpenSection(imageItem)
{
	if (sectionStates[imageItem.id] == "c") ExpandCollapse(imageItem);
}

/*	
**********
**********   End Expand/Collapse
**********
*/



/*	
**********
**********   Begin Copy Code
**********
*/

function CopyCode(key)
{
	var trElements = document.getElementsByTagName("tr");
	var i;
	for(i = 0; i < trElements.length; ++i)
	{
		if(key.parentNode.parentNode.parentNode == trElements[i].parentNode)
		{
	    if (window.clipboardData) 
      {
          // the IE-manner
          window.clipboardData.setData("Text", trElements[i].innerText);
      }
    }
	}
}

function ChangeCopyCodeIcon(key)
{
	var i;
	var imageElements = document.getElementsByName("ccImage")
	for(i=0; i<imageElements.length; ++i)
	{
		if(imageElements[i].parentNode == key)
		{
			if(imageElements[i].src == copyImage.src)
			{
				imageElements[i].src = copyHoverImage.src;
				imageElements[i].alt = copyHoverImage.alt;
				key.className = 'copyCodeOnHover';
			}
			else
			{
				imageElements[i].src = copyImage.src;
				imageElements[i].alt = copyImage.alt;
				key.className = 'copyCode';
			}
		}
	}
}

function CopyCode_CheckKey(key, eventObj)
{
	if(eventObj.keyCode == 13)
		CopyCode(key);
}

/*	
**********
**********   End Copy Code
**********
*/


/*	
**********
**********   Begin Maintain Scroll Position
**********
*/

function loadAll(){
	try 
	{
		scrollPos = allHistory.getAttribute("Scroll");
	}
	catch(e){}
}

function saveAll(){
	try
	{
		allHistory.setAttribute("Scroll", mainSection.scrollTop);
	}
	catch(e){}
}

/*	
**********
**********   End Maintain Scroll Position
**********
*/


/*	
**********
**********   Begin Send Mail
**********
*/

function formatMailToLink(anchor)
{
	var release = "Release: " + anchor.doc_Release;
	var topicId = "Topic ID: " + anchor.doc_TopicID;
	var topicTitle = "Topic Title: " + anchor.doc_TopicTitle;
	var url = "URL: " + document.URL;
	var browser = "Browser: " + window.navigator.userAgent;

	var crlf = "%0d%0a"; 
	var body = release + crlf + topicId + crlf + topicTitle + crlf + url + crlf + browser + crlf + crlf + "Comments:" + crlf + crlf;
	
	anchor.href = anchor.href + "&body=" + body;
}

/*	
**********
**********   End Send Mail
**********
*/


/*	
**********
**********   Begin Persistence
**********
*/

var globals;

// get global vars from persistent store			
function GetGlobals()
{
	var out;  
	
	// Try to get VS implementation
	try { out = window.external.Globals; }
	catch (e) { out = null; }
	
	// Try to get DExplore implementation
	try { if (out == null) out = window.external.GetObject("DTE", "").Globals; }
	catch (e) { outk = null; }
	
	return out;
}

function Save(key, value, days)
{
  if (days) 
  { 
    var date = new Date();

    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    var expires = "; expires=" + date.toGMTString(); 
  } 
  else var expires = "";
  document.cookie = key + "=" + value + expires + "; path=/";
}

function Load(key)
{
  var nameEQ = key + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) 
  { 
    var c = ca[i];
	  while (c.charAt(0) == ' ') c = c.substring(1, c.length);
	  if (c.indexOf(nameEQ) == 0) 
      return c.substring(nameEQ.length, c.length);
	}
	return null;
}
	  
/*	
**********
**********   End Persistence
**********
*/

/* This is the part for Glossary popups */
// The method is called when the user positions the mouse cursor over a glossary term in a document.
// Current implementation assumes the existence of an associative array (g_glossary). 
// The keys of the array correspond to the argument passed to this function.

var bGlossary=true;
var oDialog;
var oTimeout="";
var oTimein="";
var iTimein=.5;
var iTimeout=30;
var oLastNode;
var oNode;
var bInit=false;
var aTerms=new Array();

// Called from mouseover and when the contextmenu behavior fires oncontextopen.
function clearDef(eventObj){
    if(eventObj){
        var elem;
        if(document.all) elem = eventObj.toElement;
        else elem = eventObj.relatedTarget;
	    if(elem!=null || elem!="undefined"){
		    if(typeof(oTimein)=="number"){
			    window.clearTimeout(oTimein);
		    }
		    if(oDialog.dlg_status==true){
			    hideDef();
		    }
		}
	}
}

function hideDef(eventObj){
	window.clearTimeout(oTimeout);
	oTimeout="";
	oDialog.style.display="none";
	oDialog.dlg_status=false;	
}

function showDef(oSource){
	if(bInit==false){
		glossaryInit();
		bInit=true;
	}
	if(bGlossary==true){
		if(typeof(arguments[0])=="object"){
			oNode=oSource;
		}
		else{
		    if(document.all) oNode = eventObj.srcElement;
		    else oNode = eventObj.target;
		}
		var bStatus=oDialog.dlg_status; // BUGBUG: oDialog is null.
		if((oLastNode!=oNode)||(bStatus==false)){
			if((typeof(oTimein)=="number")&& eventObj){
			    
			    var elem;
			    if(document.all) elem = eventObj.fromElement;
			    else elem = eventObj.relatedTarget;
			    
			    if( elem != null || elem != "undefined")
				    window.clearTimeout(oTimein);
			}
			oTimein=window.setTimeout("openDialog(oNode)",iTimein*1000);
		}	
	}
}

function glossaryInit(){
		oDialog=fnCreateDialog(150,50);
}

function navigateTerm(eventObj){
    var oNode;
    if(document.all) oNode = eventObj.srcElement;
    else oNode = eventObj.target;
	
	var iTermID=oNode.termID;
	if(oNode!=aTerms[iTermID]){
		var iAbsTop=getAbsoluteTop(aTerms[iTermID]);
		if(iAbsTop<document.body.scrollTop){
			window.scrollTo(document.body.scrollLeft,getAbsoluteTop(aTerms[iTermID]));
		}
		openDialog(aTerms[iTermID]);
	}
}

function disableGlossary(eventObj){
	if(bGlossary==true){
	    if(document.all) eventObj.srcElement.innerText="Enable Automatic Glossary";
		else eventObj.target.innerText="Enable Automatic Glossary";
		bGlossary=false;
		hideDef();		
	}
	else{
	    if(document.all) eventObj.srcElement.innerText="Disable Automatic Glossary";
		else eventObj.target.innerText="Disable Automatic Glossary";
		bGlossary=true;
	}
}

function openGlossary(){

}

function fnSetMenus(eventObj){
    var oNode;
    if(document.all) oNode = eventObj.srcElement;
    else oNode = eventObj.target;
	
	var oMenu=oNode.createMenu("SPAN","G_RID");
	var oSubItem1=oNode.createMenuItem("Glossary",fnStub,oMenu,true);
	document.body.createMenuItem("Open External Glossary",openGlossary,oSubItem1.subMenu);
	document.body.createMenuItem("Disable Automatic Glossary",disableGlossary,oSubItem1.subMenu);	
	for(var i=0;i<aTerms.length;i++){
		var oItem=document.body.createMenuItem(aTerms[i].innerText,navigateTerm,oMenu);
		oItem.termID=i;
	}
}

// This is a bogus stub.  It should be sniffed out rather than added in.
function fnStub(){

}

function fnAttachMenus(aTips){
	// This walk is only necessary for the context menu.
	var aTips=document.getElementsByTagName("SPAN");
	for(var i=0;i<aTips.length;i++){
		var oNode=aTips[i];
		if(oNode.getAttribute("G_RID")){
			var sTerm=oNode.getAttribute("G_RID");
			if(typeof(g_glossary[sTerm])=="string"){
				// Removed client-side scripting to add events.  This entire process should be singled out for IE 5 and later .. and, its only for the context menu.
				aTerms[aTerms.length]=oNode;
			}
		}
	}
	if(oBD.majorVer>=5){
		document.body.addBehavior(gsContextMenuPath);
		document.body.onbehaviorready="fnSetMenus()";
		document.body.oncontextopen="clearDef()";
	}

}

// Called by showDef.  The showDef function sniffs for initialization.
function openDialog(oNode,x,y){
 	var bStatus=oDialog.dlg_status; // BUGBUG: This code assumes that oDialog has been initialized
	if(bStatus==false){
		oDialog.dlg_status=true;
		oDialog.style.display="block";
	}
	else{
		if(typeof(oTimeout)=="number"){
			window.clearTimeout(oTimeout);
		}
	}
	
	var sTerm=oNode.getAttribute("G_RID");	
	var oDef=oNode.children(0);
	var sDef=oDef.text;
	sDef=sDef.substr(4,sDef.length-7);	//Strips the html comment markers from the definition.
	oDialog.innerHTML=sDef
	
	
	//oDialog.innerHTML=g_glossary[sTerm];
		
	var iScrollLeft=document.body.scrollLeft;
	var iScrollTop=document.body.scrollTop;
	var iOffsetLeft=getAbsoluteLeft(oNode)// - iScrollLeft;
	var iOffsetWidth=oNode.offsetWidth;
	var oParent=oNode.parentNode;
	var iOffsetParentLeft=getAbsoluteLeft(oParent);
	var iOffsetTop=getAbsoluteTop(oNode); //- iScrollTop;
	var iOffsetDialogWidth=oDialog.offsetWidth;
	
	
	if((iOffsetLeft + iOffsetWidth) > (iOffsetParentLeft + oParent.offsetWidth)){
		iOffsetLeft=iOffsetParentLeft;
		if(iOffsetLeft - iOffsetDialogWidth>0){
			iOffsetTop+=oNode.offsetHeight;
		}
	}
	var iLeft=0;
	var iTop=0;
	if((iOffsetLeft + iOffsetWidth - iScrollLeft + iOffsetDialogWidth) < document.body.offsetWidth ){
		iLeft=iOffsetLeft + iOffsetWidth;
	}
	else{
		if(iOffsetLeft - iOffsetDialogWidth>0){
			iLeft=iOffsetLeft - iOffsetDialogWidth;
		}
		else{
			iLeft=iOffsetParentLeft;
		}
	}
	if(iOffsetTop - iScrollTop<oDialog.offsetHeight){
		iTop=iOffsetTop + oNode.offsetHeight;
	}
	else{
		iTop=iOffsetTop - oDialog.offsetHeight;
	}
	oDialog.style.top=iTop;
	oDialog.style.left=iLeft;
	oTimeout=window.setTimeout("hideDef()",iTimeout*1000);	
}

function getAbsoluteTop(oNode){
	var oCurrentNode=oNode;
	var iTop=0;
	while(oCurrentNode.tagName!="BODY"){
		iTop+=oCurrentNode.offsetTop;
		oCurrentNode=oCurrentNode.offsetParent;
	}
	return iTop;
}

function getAbsoluteLeft(oNode){
	var oCurrentNode=oNode;
	var iLeft=0;
	while(oCurrentNode.tagName!="BODY"){
		iLeft+=oCurrentNode.offsetLeft;
		oCurrentNode=oCurrentNode.offsetParent;
	}
	return iLeft;
}

function fnCreateDialog(iWidth,iHeight){
	document.body.insertAdjacentHTML("BeforeEnd","<DIV></DIV>");
	oNewDialog=document.body.children(document.body.children.length-1);
	oNewDialog.className="clsTooltip";
	oNewDialog.style.width=iWidth;
	oNewDialog.dlg_status=false;
	return oNewDialog;
}

function sendfeedback(subject, id,alias){
	var rExp = /\"/gi;
	var url = location.href;
	// Need to replace the double quotes with single quotes for the mailto to work.
	var rExpSingleQuotes = /\'\'"/gi;
	var title = document.getElementsByTagName("TITLE")[0].innerText.replace(rExp, "''");
	location.href = "mailto:" + alias + "?subject=" + subject + title + "&body=Topic%20ID:%20" + id + "%0d%0aURL:%20" + url + "%0d%0a%0d%0aComments:%20";
}


function AddRowToTable(tableID, className)
{
  var table = document.getElementById(tableID);
  if (table != null)
  {
    AttachRowToTable(table, className);
  }
}

function AttachRowToTable(table, className)
{
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);

    // Parameter column
    var cellLeft = row.insertCell(0);

    var divTag = document.createElement('div');
    if (className != null)
      divTag.className = className;
    divTag.setAttribute('contentEditable', 'true');
    divTag.setAttribute('tabindex', '0');

    // NOTE: onkeydown/oncut/onpaste will be captured by watchElement function.
    divTag.onkeypress = function() {
      AddSpareTableRow(table, rowCount);
    }
    watchElement(divTag);
    divTag.isEditableCell = true;
    divTag.onpaste = function(event)
    {
      AddSpareTableRow(table, rowCount);
      window.external.markAsModified();
    }

    cellLeft.appendChild(divTag);

    // alert(table.cols);
    /*
    if (table.id == 'seealso') // TEMP
        return;
    */

    // Description column
    var cellRight = row.insertCell(1);

    var divTag = document.createElement('div');
    divTag.setAttribute('contentEditable', 'true');
    divTag.setAttribute('tabindex', '0');
    divTag.onkeypress = function() {
      AddSpareTableRow(table, rowCount);
    }
    watchElement(divTag);
    divTag.isEditableCell = true;
    divTag.onpaste = function(event)
    {	    
      AddSpareTableRow(table, rowCount);
      window.external.markAsModified();
    }
    cellRight.appendChild(divTag);
}

function AddSpareTableRow(table, rowNo)
{
  if (table != null)
  {
    if (rowNo == table.rows.length - 1)
      AttachRowToTable(table);
  }
}

function RemoveRowFromTable(tableID, row)
{
  var table = document.getElementById(tableID);
  if (table != null)
    table.deleteRow(row.rowIndex);
}

function AddRowToDefTables()
{
  var tables = document.getElementsByTagName("table");

  for (i=0; i<tables.length; i++)
  {
    var table = tables(i);
    if (table.className=="definition")
    {
        AttachRowToTable(table);
    }
  }
}

function InsertHtml(htmlText)
{
  if (document != null &&
    document.selection != null &&
    document.selection.type != 'Control')
  {
    var range = document.selection.createRange();
    if (range != null &&
        range.parentElement() != null &&
        range.parentElement().isContentEditable)
    {
        range.select();
        range.pasteHTML(htmlText);
        range.collapse(false);
        window.external.markAsModified();
        watchContentEditableElements();
    }
  }
}

function InsertNote(type)
{
    var id = CreateGuid();
	InitializeConfiguration();
    var node = configurationXml.selectSingleNode("//configuration/notes/" + type);
    if (node != null && node.childNodes.length > 0)
    {
        var caption = node.childNodes[0].text;
        var iconUri = node.childNodes[1].text;
		var html =
            '<div id="' + id + '" class="note" contentEditable="false">' +
			'<input type="HIDDEN" class="note" value="'+type+'" />' +
			'<table>' +
            '	<thead>' +
            '	<tr>' +
            '		<th>' +
            '			<img src="' + iconUri + '" class="note" title="Note" />' +
            '			<span class="note">' + caption + '</span>' +
            '		</th>' +
            '	</tr>' +
            '	</thead>' +
            '	<tbody>' +
            '		<tr>' +
            '			<td>' +
            '				<div contentEditable="true">' +
            '					<p></p>' +
            '				</div>' +
            '			</td>' +
            '		</tr>' +
            '	</tbody>' +
            '</table>' +
            '</div>';
        InsertHtml(html);
		focusEditableContent(id);
    }
}

function InsertCode(lang)
{
	var id = CreateGuid();
    var caption="Code";
    var html=
        '<div id="' + id + '" class="code" contentEditable="false">' +
          '<input class="code" type="HIDDEN" value="Delphi" />' +
          '<span codeLanguage="other">' +
            '<table width="100%" cellspacing="0" cellpadding="0">' +
              '<tr>' +
                '<th>' + caption + '</th>' +
                '<th>' +
                  '<span class="copyCode" onclick="CopyCode(this)"' +
                    'onkeypress="CopyCode_CheckKey(this)" onmouseover="ChangeCopyCodeIcon(this)"' +
                    'onfocusin="ChangeCopyCodeIcon(this)" onmouseout="ChangeCopyCodeIcon(this)"' +
                    'onfocusout="ChangeCopyCodeIcon(this)" tabindex="0">' +
                  '<img class="copyCodeImage" name="ccImage" align="absmiddle"' +
                    'alt="CopyCode image" src="images/copycode.gif"/>Copy Code</span>' +
                '</th>' +
              '</tr>' +
              '<tr>' +
                '<td colspan="2">' +
                  '<div class="codeEditor" contentEditable="true">' +
                    '<pre></pre>' +
                  '</div>' +
                '</td>' +
              '</tr>' +
            '</table>' +
          '</span>' +
        '</div>';
    InsertHtml(html);
	focusEditableContent(id);
}

function S4() {
   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}

function CreateGuid() {
   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

function InsertDefinitionTable()
{
    var id = CreateGuid();
    //*
    var html =
        '<div contentEditable="false">' +
        '<table id="' + id + '" class="definition">' +
        '	<thead>' +
        '		<tr>' +
        '			<td class="termColumn"><div contentEditable="true">Term</div></td>' +
        '			<td class="descriptionColumn"><div contentEditable="true">Description</div></td>' +
        '		</tr>' +
        '	</thead>' +
        '	<tbody>' +
        '		<tr>' +
        '			<td class="term"><div contentEditable="true"><p /></div></td>' +
        '			<td class="description"><div contentEditable="true"><p /></div></td>' +
        '		</tr>' +
        '	</tbody>' +
        '</table></div>';
    //*/
    InsertHtml(html);
    AddRowToTable(id);
	focusEditableContent(id);
}

function focusEditableContent(id)
{
	var target;
	var elements;
	var element;

	target = document.getElementById(id);
	if (target != null) {
		elements = target.getElementsByTagName('div');
		for (var i = 0; i < elements.length; i++) { 
			if (elements[i].contentEditable=='true') {
				elements[i].focus();
				break;
			}
		}
	}
}

function watchContentEditableElements()
{
    if (contentEditableControl.value == "true")
    {
      var elements = document.getElementsByTagName('div');
      var element, i;
      var attribute;
      for (i = 0; i < elements.length; i++)
      {
        element = elements[i];
        watchElement(element);
      }
    }
}

function watchElement(element)
{
    if (element.contentEditable == 'true')
    {
      element.onkeydown = function(event)
      {
        dokeydown(event);
      }
      element.oncut = function(event)
      {
        docut(event);
      }
      if (element.isEditableCell == null ||
        element.isEditableCell != true)
      {
          element.onpaste = function(event)
          {
            dopaste(event);
          }
      }
    }
}

function dokeydown(event)
{
  if (!event)
  {
    event = window.event;
    var target = event.srcElement;
  }
  else
    var target = event.target;
  // Ignore:
  // Ctrl, Shift, Tab, Home, End, Page Up/Down, Arrow Left/Right/Up/Down
  // Ctrl-A/C
  if (event.keyCode != 16 && event.keyCode != 17 &&
    event.keyCode != 9 &&
    (event.keyCode < 33 || event.keyCode > 40))
  {
    if (!event.ctrlKey || ((event.keyCode != 65) && (event.keyCode != 67)))
    {
        window.external.markAsModified();
    }
  }
}

function docut(event)
{
  if (!event)
  {
    event = window.event;
    var target = event.srcElement;
  }
  else
    var target = event.target;

  window.external.markAsModified();
}

function dopaste(event)
{
  if (!event)
  {
    event = window.event;
    var target = event.srcElement;
  }
  else
    var target = event.target;

  window.external.markAsModified();
}

/*
function focus(event)
{
  if (!event)
  {
    event = window.event;
    target = event.srcElement;
  }
  else
    target = event.target;
    
  editableContent = target.innerHTML;
}

function lostFocus(event)
{
  if (!event)
  {
    event = window.event;
    var target = event.srcElement;
  }
  else
  {
    var target = event.target;
  }
  
  if (compareContent(target))
    window.external.markAsModified();
}

function compareContent(element) 
{
  return editableContent != element.innerHTML;
}
*/
