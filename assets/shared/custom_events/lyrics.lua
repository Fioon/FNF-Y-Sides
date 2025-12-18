function onEvent(name, value1, value2)
    if name == 'lyrics' then

        makeLuaText('lyricsText', value1 or '', 1280, 0, getProperty('healthBar.y') - 80)
        setObjectCamera('lyricsText', 'hud')
        setTextSize('lyricsText', value2)
        setTextAlignment('lyricsText', 'center')    
        addLuaText('lyricsText')

        setProperty('lyricsText.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing', false, false))
    end
end
