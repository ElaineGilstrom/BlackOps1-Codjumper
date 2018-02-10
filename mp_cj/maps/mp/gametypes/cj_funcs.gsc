connect() {
	self.cjSaves = [];
	self.cjIndx = 0;
}

spawn() {
	self thread saveload();
}

saveload() {//based off of the saveload system by Drofder, but heavily modified.
	self endon("death");
	self endon("killed_player");
	self endon("joined_spectators");
	self endon("disconnect");

	for(;;) {
		if(self meleeButtonPressed()) {
			x = false;
			for(i = 0;i < 0.5;i += 0.05) {
				if(!self isMantling() && !self isOnLadder() && self isOnGround() && x) {
					if(self meleeButtonPressed()) {
						self savePos();

						wait 0.75;

						break;
					}
				} else if(!self meleeButtonPressed() && !x) x = true;

				wait 0.05;
			}
		} else if(self useButtonPressed()) {
			x = false;
			for(i = 0;i < 0.5;i += 0.05) {
				if(!self isMantling() && x) {
					if(self useButtonPressed()) {
						self loadPos(self.cjIndx);

						wait 0.75;

						break;
					}
				} else if(!self useButtonPressed() && !x) x = true;
				
				if(self attackButtonPressed()) {
					self doBackload();

					break;
				}
				
				wait 0.05;
			}
		}

		wait 0.05;
	}
}

doBackload() {
	ln = self.cjIndx;
	while(self useButtonPressed()) {
		if(self attackButtonPressed()) {
			if(ln < 0) ln = 500;
			if(!loadPos(ln)) break;
			wait 0.2;
		}
		wait 0.05;
	}
}

loadPos(indx) {
	if(isDefined(self.cjSaves[indx])) {
		self iPrintLn("^8P^7osition " + indx + " Loaded.");
		self setOrigin(self.cjSaves[indx][0]);
		self setPlayerAngles(self.cjSaves[indx][1]);

		self freezeControls(true);
		wait 0.1;
		self freezeControls(false);
		
		return true;
	} else {
		self iPrintLn("^8P^7osition " + indx + " Undefined.");
		
		return false;
	}
}

savePos() {
	if(self.cjIndx >= 500) self.cjIndx = 0;
	self.cjSaves[self.cjIndx] = [self.origin, self.angles];
	self iPrintLn("^8P^7osition " + self.cjIndx + " Saved.");
	self.cjIndx += 1;
}
