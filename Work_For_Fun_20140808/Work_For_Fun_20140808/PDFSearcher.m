//
//  PDFSearcher.h
//  Work_For_Fun_20140808

#import "PDFSearcher.h"

@interface PDFSearcher()

@property (nonatomic, assign) CGPDFOperatorTableRef table;

@end

@implementation PDFSearcher

void arrayCallback(CGPDFScannerRef inScanner, void *userInfo)
{
    PDFSearcher * searcher = (__bridge PDFSearcher *)userInfo;

    CGPDFArrayRef array;

    bool success = CGPDFScannerPopArray(inScanner, &array);

    for(size_t n = 0; n < CGPDFArrayGetCount(array); n += 2)
    {
        if(n >= CGPDFArrayGetCount(array))
            continue;

        CGPDFStringRef string;
        success = CGPDFArrayGetString(array, n, &string);
        if(success)
        {
            NSString *data = (__bridge NSString *)CGPDFStringCopyTextString(string);
            NSLog(@"%@", data);
            [searcher.currentData appendFormat:@"%@", data];
        }
    }
}

void stringCallback(CGPDFScannerRef inScanner, void *userInfo)
{
    PDFSearcher *searcher = (__bridge PDFSearcher *)userInfo;

    CGPDFStringRef string;

    bool success = CGPDFScannerPopString(inScanner, &string);

    if(success)
    {
        NSString *data = (__bridge NSString *)CGPDFStringCopyTextString(string);
        NSLog(@"%@", data);
        [searcher.currentData appendFormat:@"%@", data];
    }
}

-(id)init
{
    if(self = [super init])
    {
        _table = CGPDFOperatorTableCreate();
        CGPDFOperatorTableSetCallback(_table, "TJ", arrayCallback);
        CGPDFOperatorTableSetCallback(_table, "Tj", stringCallback);
    }
    return self;
}

-(BOOL)page:(CGPDFPageRef)inPage containsString:(NSString *)inSearchString
{
    [self setCurrentData:[NSMutableString string]];
    CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(inPage);
    CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, _table, (__bridge void *)(self));
    bool ret = CGPDFScannerScan(scanner);
    CGPDFScannerRelease(scanner);
    CGPDFContentStreamRelease(contentStream);
    //NSLog(@"%u, %@", [self.currentData length], self.currentData);
//    return ([[self.currentData uppercaseString]
//             rangeOfString:[inSearchString uppercaseString]].location != NSNotFound);
    NSLog(@"-----------> %@", self.currentData);
    return YES;
}
@end