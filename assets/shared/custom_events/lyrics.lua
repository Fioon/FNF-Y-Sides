function onEvent(name, value1, value2)
    if name == 'lyrics' then

        local value_2 = stringSplit(value2, ",")
        makeLuaText('lyricsText', value1 or '', 1280, 0, getProperty('healthBar.y') - 80)
        setObjectCamera('lyricsText', 'hud')
        setTextSize('lyricsText', value_2[1] or 32)
        setTextColor('lyricsText', value_2[2] or 'FFFFFF')
        setTextAlignment('lyricsText', 'center')    
        addLuaText('lyricsText')

        if getPropertyFromClass('backend.ClientPrefs', 'data.downScroll') then
            setProperty('lyricsText.y', getProperty('healthBar.y') + getProperty('healthBar.height') + 80)
        end

        setProperty('lyricsText.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing', false, false))
    end
end
