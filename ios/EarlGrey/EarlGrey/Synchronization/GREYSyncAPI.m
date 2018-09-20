//
// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Synchronization/GREYSyncAPI.h"

#import "Assertion/GREYAssertionDefines.h"

void grey_execute_sync(void (^block)()) {
  if ([NSThread isMainThread]) {
    NSLog(@"grey_execute_sync() cannot be invoked on the main thread. Aborting.");
    abort();
  }

  dispatch_semaphore_t waitForBlock = dispatch_semaphore_create(0);
  CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopDefaultMode, ^{
    block();
    dispatch_semaphore_signal(waitForBlock);
  });
  // CFRunLoopPerformBlock does not wake up the main queue.
  CFRunLoopWakeUp(CFRunLoopGetMain());
  // Waits until block is executed and semaphore is signalled.
  dispatch_semaphore_wait(waitForBlock, DISPATCH_TIME_FOREVER);
}

void grey_execute_async(void (^block)()) {
  CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopDefaultMode, block);
  // CFRunLoopPerformBlock does not wake up the main queue.
  CFRunLoopWakeUp(CFRunLoopGetMain());
}
