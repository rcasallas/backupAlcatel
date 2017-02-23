    my $host =$ARGV[0];
    my $nodePBX = $ARGV[1];
    my $DateBackup = $ARGV[2];
    my $company = $ARGV[3];
    my $IsvoiceMail =$ARGV[4];
    my $pathEva_msg = "";
    my $dest =$ARGV[5];
    my $user =$ARGV[6];
    my $passwd =$ARGV[7];
    if ($IsvoiceMail eq "1")
    {
   	$pathEva_msg = "/usr4/BACKUP/IMMED/eva-msg";
    }
    

    my $commandMainRepository = "scp -2 -rp $pathEva_msg /usr4/BACKUP/IMMED/mao-acc /usr4/BACKUP/IMMED/vg /usr4/BACKUP/IMMED/mao-dat /usr4/BACKUP/IMMED/obstraf /usr4/BACKUP/IMMED/cho-dat /usr4/BACKUP/IMMED/acc /usr4/BACKUP/IMMED/acd /usr4/BACKUP/IMMED/mao telefonia\@10.185.8.24:/home/telefonia/alcatel/$nodePBX/$DateBackup";

    my $commandBackupRepository = "scp -2 -rp /home/telefonia/alcatel/$nodePBX/$DateBackup/ telefonia\@$dest:/Data/backups/Alcatel/$nodePBX";
    my $user = '';
    my $passwd = '';
    
    print $commandMainRepository;
    print $commandBackupRepository;

    my ($t, @output,$file);
    
    system("user: $user");
    system("password: $passwd"); 
   
    $file = "/home/telefonia/alcatel/$nodePBX/$DateBackup/".$nodePBX."-".$DateBackup.".log";
	
    ## Create a Net::Telnet object.
    use Net::Telnet ();
    $t = new Net::Telnet (Timeout  => 10,
			  Input_log  => $file	

				);

    ## Connect and login.
    $t->open($host);

    $t->waitfor('/login: ?$/i');
    $t->print($user);

    $t->waitfor('/Password: ?$/i');
    $t->print($passwd);


    $t->print("su swinst");
    $t->waitfor(Match => '/Password: ?$/i', Timeout => 20);
    $t->print('SoftInst'); 
    ## @output = $t->cmd("SoftInst");
    @output = $t->cmd("cd /DHS3bin/soft_install/bin/");
    
    @output = $t->print("./bck -save mao");
    print @output;
    $t->waitfor(Match => '/> ?$/i', Timeout => 180);

    @output = $t->print("./bck -save mao-acc");
    $t->waitfor(Match => '/> ?$/i', Timeout => 500 );

    @output = $t->print("./bck -save vg");
    $t->waitfor(Match => '/> ?$/i', Timeout => 180);

    @output = $t->print("./bck -save mao-dat");
    $t->waitfor(Match => '/> ?$/i', Timeout =>180); 
    
    @output = $t->print("./bck -save obstraf");
    $t->waitfor(Match => '/> ?$/i', Timeout => 180);

    @output = $t->print("./bck -save cho-dat");
    $t->waitfor(Match => '/> ?$/i', Timeout => 180);

    @output = $t->print("./bck -save acc");
    $t->waitfor(Match => '/> ?$/i', Timeout => 180);

    @output = $t->print("./bck -save acd");
    $t->waitfor(Match => '/> ?$/i', Timeout => 180);

    if ($IsvoiceMail eq "1")
    {
	@output = $t->print("./bck -save eva-msg");
        $t->waitfor(Match => '/> ?$/i', Timeout => 600);
    }
    ##print $commandMainRepository;
    @output = $t->print($commandMainRepository);
    $t->waitfor(Match => '/password: ?$/i', Timeout => 20);
    $t->print('password');
    $t->waitfor(Match => '/> ?$/i', Timeout =>900);
    
    ##print $commandBackupRepository;
    system($commandBackupRepository);
    ## $t->waitfor(Match => '/password: ?$/i', Timeout => 20);
    ## $t->print('Telcosyn.');
    ## $t->waitfor(Match => '/> ?$/i', Timeout => 900);   

    @output = $t->print("exit");
    @output = $t->print("exit");
    ## print @output;
    exit;
