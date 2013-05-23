
sub SetupUI(){

	#
	# Global variables
	#
	my (
		 # MainWindow
		 $MW,

		 # Hash of all widgets
		 %ZWIDGETS,
		);

	#
	# User-defined variables (if any)
	#


	######################
	#
	# Create the MainWindow
	#
	######################

	$MW = MainWindow->new;
	$MW->minsize(100,600);
	$MW->gridRowconfigure(0, -weight => 1);
	# Widget Labelframe1 isa Labelframe
	$ZWIDGETS{'Labelframe1'} = $MW->Labelframe(
	   -takefocus => 0,
	   -text      => 'TV Shows',
	  )->grid(
	   -row     => 0,
	   -column  => 0,
	   -rowspan => 3,
	   -sticky  => 'nsew',
	  );
	  $ZWIDGETS{'Labelframe1'}->gridRowconfigure(0, -weight => 1);

	# Widget shwList isa HList
	$ZWIDGETS{'shwList'} = $ZWIDGETS{Labelframe1}->Scrolled('Tree',
	   -scrollbars      => 'oe',
	   -command         => 'main::loadEpisodeList',
	   -exportselection => 0,
	   -separator	    => '/',
	   -width  =>30,
	   #-height =>28,
	   -indicator =>1
	  )->grid(
	   -row    => 0,
	   -column => 0,
	   -sticky  => 'nsew',
	  );
	  
	# Widget addShows isa Button
	$ZWIDGETS{'addShows'} = $ZWIDGETS{Labelframe1}->Button(
	   -command => 'main::editShows',
	   -text    => 'Edit Shows',
	  )->grid(
	   -row    => 1,
	   -column => 0,
	  );

	# Widget Labelframe2 isa Labelframe
	$ZWIDGETS{'Labelframe2'} = $MW->Labelframe(
	   -takefocus => 0,
	   -text      => 'Episode List',
	  )->grid(
	   -row     => 0,
	   -column  => 1,
	   -rowspan => 3,
	   -sticky  => 'nsew',
	  );
	  
	  $ZWIDGETS{'Labelframe2'}->gridRowconfigure(0, -weight => 1);

	  
	# Widget epiList isa HList
	$ZWIDGETS{'epiList'} = $ZWIDGETS{Labelframe2}->Scrolled('HList',
	   -scrollbars      => 'oe',
	   -command => 'main::playSelected',
	   -exportselection => 0,
	   -separator	    => '/',
	   -width           => 70,
	  # -height => 30
	  )->grid(
	   -row    => 0,
	   -column => 0,   
	   -columnspan => 2,
	   -sticky  => 'nsew',
	  );
	  

	# Widget artwork isa Image
	$ZWIDGETS{'artwork'} = $MW->Label(
	   -relief    => 'flat',
	   -state     => 'normal',
	   -takefocus => 0,
	  )->grid(
	   -row    => 0,
	   -column => 2,
	  );

	# Widget Labelframe3 isa Labelframe
	$ZWIDGETS{'Labelframe3'} = $MW->Labelframe(
	   -takefocus => 0,
	   -text      => 'Settings',
	  )->grid(
	   -row    => 1,
	   -column => 2,
	   -sticky => 'nsew',
	  );

	# Widget Labelframe4 isa Labelframe
	$ZWIDGETS{'Labelframe4'} = $ZWIDGETS{Labelframe3}->Labelframe(
	   -takefocus => 0,

	   -text      => 'Pattern',
	  )->grid(
	   -row    => 1,
	   -column => 0,
	   -sticky => 'nsew',
	  );

	# Widget Entry1 isa Entry
	$ZWIDGETS{'pattern'} = $ZWIDGETS{Labelframe4}->Entry(
	   -textvariable => \$show{pattern},
	  )->grid(
	   -row    => 0,
	   -column => 0,
	  );

	# Widget Button1 isa Button
	$ZWIDGETS{'Button1'} = $ZWIDGETS{Labelframe4}->Button(
	   -command => 'main::saveShowDetails',
	   -text    => 'Set',
	  )->grid(
	   -row    => 0,
	   -column => 1,
	  );

	# Widget Labelframe5 isa Labelframe
	$ZWIDGETS{'Labelframe5'} = $ZWIDGETS{Labelframe3}->Labelframe(
	   -takefocus => 0,
	   -text      => 'Last Played',
	  )->grid(
	   -row    => 2,
	   -column => 0,
	   -sticky => 'nsew',
	  );

	# Widget Label1 isa Label
	$ZWIDGETS{'lastPlayed'} = $ZWIDGETS{Labelframe5}->Label(
	   -padx         => 1,
	   -pady         => 1,
	   -text         => 'Last played here',
	   -textvariable => \$show{lastPlayed},
	  )->grid(
	   -row    => 0,
	   -column => 0,
	  );

	# Widget Labelframe7 isa Labelframe
	$ZWIDGETS{'Labelframe7'} = $MW->Labelframe(
	   -takefocus => 0,
	   -text      => 'Actions',
	  )->grid(
	   -row    => 2,
	   -column => 2,
	   -sticky => 'nsew',
	  );

	# Widget pNext isa Button
	$ZWIDGETS{'pNext'} = $ZWIDGETS{Labelframe7}->Button(
	   -command => 'main::playNext',
	   -padx    => 0,
	   -relief  => 'raised',
	   -state   => 'normal',
	   -text    => 'Play Next',
	   -width   => 0,
	  )->grid(
	   -row    => 0,
	   -column => 0,
	   -sticky => 'nsew',
	  );

	# Widget startHere isa Button
	$ZWIDGETS{'startHere'} = $ZWIDGETS{Labelframe7}->Button(
	   -command => 'main::startOrderHere',
	   -text    => 'Start from Selected',
	  )->grid(
	   -row    => 1,
	   -column => 0,
	   -sticky => 'nsew',
	  );

	# Widget pRand isa Button
	$ZWIDGETS{'pRand'} = $ZWIDGETS{Labelframe7}->Button(
	   -command => 'main::playRandom',
	   -text    => 'Random',
	  )->grid(
	   -row    => 0,
	   -column => 1,
	   -sticky => 'nsew',
	  );

	# Widget deskShort isa Button
	$ZWIDGETS{'deskShort'} = $ZWIDGETS{Labelframe7}->Button(
	   -command => 'main::indicateNewEpisodes',
	   -text    => 'Check Latest Episodes',
	  )->grid(
	   -row    => 1,
	   -column => 1,
	   -sticky => 'nsew',
	  );

	($MW,%ZWIDGETS);

}

1;
