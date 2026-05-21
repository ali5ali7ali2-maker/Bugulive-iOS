//
//  LocalizationSystem.m
//  Battle of Puppets
//
//  Created by Juan Albero Sanchis on 27/02/10.
//  Copyright Aggressive Mediocrity 2010. All rights reserved.
//

#import "LocalizationSystem.h"
#import "NSBundle+Language.h""
@implementation LocalizationSystem

//Singleton instance
static LocalizationSystem *_sharedLocalSystem = nil;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;

+(LocalizationSystem *)sharedLocalSystem {
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        _sharedLocalSystem = [[super allocWithZone:nil] init];
//        [_sharedLocalSystem setLanguage:[_sharedLocalSystem getLanguage]];
    });
    return _sharedLocalSystem;
}

- (id)init {
    if (_sharedLocalSystem) {
        return _sharedLocalSystem;
    }
    if (self = [super init]) {
        
        //
    }
    return self;
}

- (id)copy {
    return [[self class] sharedLocalSystem];
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedLocalSystem];
}

+(id)alloc
{
	@synchronized([LocalizationSystem class])
	{
		NSAssert(_sharedLocalSystem == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedLocalSystem = [super alloc];
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}

// Gets the current localized string as in NSLocalizedString.
//
// example calls:
// AMLocalizedString(@"Text to localize",@"Alternative text, in case hte other is not find");
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment
{
    if (!bundle) {
        bundle = nil;
    }
	return [bundle localizedStringForKey:key value:comment table:nil];
}


// Sets the desired language of the ones you have.
// example calls:
// LocalizationSetLanguage(@"Italian");
// LocalizationSetLanguage(@"German");
// LocalizationSetLanguage(@"Spanish");
// 
// If this function is not called it will use the default OS language.
// If the language does not exists y returns the default OS language.
- (void) setLanguage:(NSString*) l{
#ifdef DEBUG
	NSLog(@"preferredLang: %@", l);
#endif
    // 设置语言
    [NSBundle setLanguage:l];
	
//    [[NSUserDefaults standardUserDefaults] setObject:@[l] forKey:@"AppleLanguages"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@[l] forKey:@"AppleLanguages"];

    [[NSUserDefaults standardUserDefaults] setObject:@[l] forKey:KAppLanguageFirst];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
//
//    if ([l isEqualToString:@"en"]) {
//        path = [[ NSBundle mainBundle ] pathForResource:@"Base" ofType:@"lproj" ];
//    }
//    if (path == nil) {
//		//in case the language does not exists
//		[self resetLocalization];
//    }
//    else {
//		bundle = [NSBundle bundleWithPath:path];
//        //
//        [[NSUserDefaults standardUserDefaults] setObject:@[l] forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] setObject:@[l] forKey:KAppLanguageFirst];
//        //
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

// Just gets the current setted up language.
// returns "es","fr",...
//
// example call:
// NSString * currentL = LocalizationGetLanguage;
- (NSString*) getLanguage{

	NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];

	NSString *preferredLang = [languages objectAtIndex:0];

	return preferredLang;
}

// Resets the localization system, so it uses the OS default language.
//
// example call:
// LocalizationReset;
- (void) resetLocalization
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

+(void)checkXibString:(NSString *)string{
    
    if (string.length  < 1 || [string isEqualToString:@"(null)"]) {
        return;
    }
    
#ifdef DEBUG
    
    //获取沙盒路径
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //获取文件路径
    NSString *fullName = [NSString stringWithFormat:@"%@.txt", @"chinese"];
    NSString *theFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fullName];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *content = [NSString stringWithFormat:@"\"%@\" = \"%@\";\n",string,string];
    
    //如果文件不存在 创建文件
    if(![fileManager fileExistsAtPath:theFilePath]){
        [@"chinese.txt" writeToFile:theFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSString *txtContent = [NSString stringWithContentsOfFile:theFilePath encoding:NSUTF8StringEncoding error:nil];
//        NSMutableArray *arr = [NSMutableArray array];
        NSArray *array = [txtContent componentsSeparatedByString:@";"];
        
        NSArray *newarr = [array valueForKeyPath:@"@distinctUnionOfObjects.self"];
//        NSLog(@"%@",newarr);
//        NSLog(@"%@",[newarr componentsJoinedByString:@";"]);
    }
    
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:theFilePath];
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData]; //追加写入数据
    [fileHandle closeFile];
#endif
}



@end
