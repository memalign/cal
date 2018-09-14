#!/usr/bin/ruby

def max(arr)
    best = arr[0]
    arr.each { |x|
        if(x > best)
            best = x
        end
    }
    return best
end

def getwidth(arr)
    ret = arr[0].length
    arr.each { |x|
        ret = max([ret, x.length])
    }
    return ret
end

def formatDay(str, month, year)
    str.gsub!("\x5f\x08", "")

    if(month == Time.now.month && year == Time.now.year)
      return str.sub(/\b#{Time.now.day}\b/, "\033[7m#{Time.now.day}\033[0m")
    end
    return str
end

def printMonth(month, year)
    cur = `cal #{month} #{year}`.split("\n")
    curwid = getwidth(cur)

    cur.each { |x|
        puts formatDay(x, month, year).ljust(curwid)
    }
    puts ""
end

def printCalRow(month, year)
    prevmon = month-1
    prevyear = year
    if(prevmon < 1)
        prevmon = 12
        prevyear = year-1
    end
    prev = `cal #{prevmon} #{prevyear}`.split("\n")
    cur = `cal #{month} #{year}`.split("\n")
    nextmon = month+1
    nextyear = year
    if(nextmon > 12)
        nextmon = 1
        nextyear = year+1
    end
    nex = `cal #{nextmon} #{nextyear}`.split("\n")

    #figure out the width to pad each portion to
    prevwid = getwidth(prev)
    curwid = getwidth(cur)
    nexwid = getwidth(nex)

    numlines = max([prev.length, cur.length, nex.length])
    (0..numlines).each { |x|
        if(prev[x].nil?)
            prev[x] = ""
        end
        if(cur[x].nil?)
            cur[x] = ""
        end
        if(nex[x].nil?)
            nex[x] = ""
        end

        prev[x] = formatDay(prev[x], prevmon, prevyear)
        cur[x] = formatDay(cur[x], month, year)
        nex[x] = formatDay(nex[x], nextmon, nextyear)
        wid = !(cur[x].include? "\033") ? curwid : curwid + 8
        puts "#{prev[x].ljust(prevwid)}  #{cur[x].ljust(wid)}  #{nex[x].ljust(nexwid)}"
    }
end

#if it's cal -3 or cal curyear then we take over
#otherwise, we can use the normal cal

cmd = ""
ARGV.each { |x|
  cmd << x;
}

if(cmd == "")
    printMonth(Time.now.month, Time.now.year)
elsif(cmd == "-3")
    printCalRow(Time.now.month, Time.now.year)
elsif(cmd == "#{Time.now.year}") 
    (0..3).each { |x|
        printCalRow(3*x+2, Time.now.year)
    }
else
    puts `cal #{cmd}`
end
