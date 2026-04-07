function opponentNoteHit()
{
	switch (Math.abs(noteData))
	{
		case 2:
			PlayState.instance.dad.playAnim('singUP-alt', true);
		case 3:
			PlayState.instance.dad.playAnim('singRIGHT-alt', true);
		case 1:
			PlayState.instance.dad.playAnim('singDOWN-alt', true);
		case 0:
			PlayState.instance.dad.playAnim('singLEFT-alt', true);
	}
}

function playerNoteHit()
{
	switch (Math.abs(noteData))
	{
		case 2:
			PlayState.instance.boyfriend.playAnim('singUP-alt', true);
		case 3:
			PlayState.instance.boyfriend.playAnim('singRIGHT-alt', true);
		case 1:
			PlayState.instance.boyfriend.playAnim('singDOWN-alt', true);
		case 0:
			PlayState.instance.boyfriend.playAnim('singLEFT-alt', true);
	}
}