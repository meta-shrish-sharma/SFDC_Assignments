const displayedImage = document.querySelector('.displayed-img');
const thumbBar = document.querySelector('.thumb-bar');

const btn = document.querySelector('button');
const overlay = document.querySelector('.overlay');

/* Looping through images */

for(let i = 1; i <= 5; i++)
{
	const newImage = document.createElement('img');
	newImage.setAttribute('src', 'images/pic'+ i +'.jpg');
	newImage.setAttribute('onclick', 'setDisplayValue(this)');
	thumbBar.appendChild(newImage);
}

/* Wiring up the Darken/Lighten button */

function handleDarkLight(e){
	if(e.className == 'dark'){
		btn.setAttribute('class', 'light');	
		btn.textContent = 'light';
		overlay.setAttribute('class', 'light');	
	}
	else{
		btn.setAttribute('class', 'dark');	
		btn.textContent = 'dark';
		overlay.setAttribute('class', 'dark');
	}
}

function setDisplayValue(e){
	displayedImage.setAttribute('src', e.src);
}
