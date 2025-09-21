function onBeatHit()
    if curBeat % 2 == 0 then
        objectPlayAnimation('sprite2', 'idle1', false)
    else
        objectPlayAnimation('sprite2', 'idle2', false)    
    end
end

function onCreate()
    setBlendMode('sprite5', 'add')
    setProperty('sprite5.alpha', 0.5)
end
