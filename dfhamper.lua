-- finds all clothes in stockpile and workshop
-- original author: Christoth
-- scripts/hamper.lua

--[[=begin

dfhamper
========
Searches through your stockpiles as well as clothier and leather work
workshops for unowned articles of clothing, and returns a count of each
item type found. 

=end]]

local utils = require('utils')
local args = {...}

--counters for type of clothing
gloves = 0;
Lgloves = 0;
Rgloves = 0;
mittens = 0;
Lmittens = 0;
Rmittens = 0;
trousers = 0;
socks = 0;
shoes = 0;
dresses = 0;
robes = 0;
cloaks = 0;
tunics = 0;
vests = 0;
caps = 0;
hoods = 0;
----------------------------------
--find all stockpiles
--find all clothier and leatherworker shops
local piles = {}
local shops = {}
--grab all stockpiles, clothiers, and leather workshops and put in tables
for k, v in ipairs(df.global.world.buildings.all) do
  local str = utils.getBuildingName(v)
  if string.find(str, "Stockpile") then
    
    table.insert(piles, v)
    
  elseif string.find(str, "Clothier") or string.find(str, 'Leather') then
    
    table.insert(shops, v)
  end
end

--search through piles and shops for clothes
for k, v in ipairs(piles) do
  
  local contents = dfhack.buildings.getStockpileContents(v)
  
  for i, j in ipairs(contents) do
    
    local thing = get_type(j)
    --check if bin and look inside if
    if thing == 'bin' then
      
      local bincon = dfhack.items.getContainedItems(j)
      for m, n in ipairs(bincon) do
        count_clothes(n)
        
      end
    --otherwise count 
    else
      count_clothes(j)
    end  
  end
end

for k, v in ipairs(shops) do
 
  local contents = v.contained_items
 
  
  for i=0, #contents-1 do
    local contained = contents[i]
    count_clothes(contained.item)    
  end
end

--display results
displaycount()

--functions
---------------------------
function get_type(item)
  return string.match(tostring(item._type),"<type: item_(.+)st>"):lower()
end
---------------------------
function count_clothes(item)
  
  if dfhack.items.getOwner(item) == nil then
  local chkstr = get_type(item)
  
  if chkstr == 'shoes' then
   
    if item.subtype.name == 'sock' then
     
      socks = socks+1
     
    elseif item.subtype.name == 'shoe' then
     
      shoes = shoes+1
    end
  
  elseif chkstr == 'gloves' then
    
    if item.subtype.name == 'glove' then
     
      if item.getGloveHandedness(item) == 1 then
        Lgloves = Lgloves + 1
      elseif item.getGloveHandedness(item) == 2 then
        Rgloves = Rgloves + 1
      end
      gloves = gloves + 1
    elseif item.subtype.name == 'mitten' then
    
      if item.getGloveHandedness(item) == 1 then
        Lmittens = Lmittens + 1
      elseif item.getGloveHandedness(item) == 2 then
        Rmittens = Rmittens + 1
      end
      mittens = mittens + 1
    end
    
  elseif chkstr == 'armor' then
    
    if item.subtype.name == 'dress' then
    
      dresses = dresses + 1
    elseif item.subtype.name == 'robe' then
    
      robes = robes + 1
    elseif item.subtype.name == 'cloak' then
      
      cloaks = cloaks + 1
    elseif item.subtype.name == 'tunic' then
      tunics = tunics + 1
    elseif item.subtype.name == 'vest' then
      vests = vests + 1
    end
    
  elseif chkstr == 'helm' then
   
    if item.subtype.name == 'cap' then
      caps = caps + 1
    elseif item.subtype.name == 'hood' then
       hoods = hoods + 1
    end
    
  elseif chkstr == 'pants' then
    if item.subtype.name == 'trousers' then
      trousers = trousers + 1
    end
    
  end
  end  
   
end
----------------------------------------------

function displaycount()
  print('all unowned items of clothing found in stockpiles and workshops:')
  print(' ')
  
  if Rgloves == Lgloves then
    print('found '..Rgloves..' pairs of gloves')
  else
    print('found '..gloves..' total gloves')
    print('found '..Rgloves..' right gloves')
    print('found '..Lgloves..' left gloves')
  end
  if Rmittens == Lmittens then
    print('found '..Rmittens..' pairs of mittens')
  else
    print('found '..mittens..' total mittens')
    print('found '..Rmittens..' right mittens')
    print('found '..Lmittens..' left mittens')
  end
  if socks % 2 == 0 then
    local sockpair = socks / 2
    print('found '..sockpair..' pairs of socks')
  else
    print('found '..socks..' individual socks')
  end
  if shoes % 2 == 0 then
    local shoepair = shoes / 2
    print('found '..shoepair..' pairs of shoes')
  else
    print('found '..shoes..' individual shoes')
  end
  print('found '..cloaks..' cloaks')
  print('found '..dresses..' dresses')
  print('found '..robes..' robes')
  print('found '..tunics..' tunics')
  print('found '..vests..' vests')
  print('found '..caps..' caps')
  print('found '..hoods..' hoods')
  print('found '..trousers..' trousers')
end
------------------------------------------------------